const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {beforeUserCreated} = require("firebase-functions/v2/identity");
const {initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

initializeApp();

const MANAGER_ROLES = ["Admin", "Director"];
const ALLOWED_ROLES = ["Admin", "Director", "Teacher", "Student"];

function requireAuth(request) {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
}

function requireManager(callerRole) {
  if (!MANAGER_ROLES.includes(callerRole)) {
    throw new HttpsError(
      "permission-denied",
      "Only Admin or Director can perform this action.",
    );
  }
}

function parseAssignedClasses(value) {
  if (Array.isArray(value)) {
    return value.map((item) => String(item).trim()).filter(Boolean);
  }
  if (typeof value === "string") {
    return value.split(",").map((item) => item.trim()).filter(Boolean);
  }
  return [];
}

async function getCallerRole(uid) {
  const snap = await getFirestore().collection("users").doc(uid).get();
  return snap.data()?.role || "";
}

async function getNextEmployeeId(db) {
  const counterRef = db.collection("config").doc("user_counters");
  return db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(counterRef);
    const nextIndex = (snapshot.exists ? snapshot.data()?.last_index ?? 0 : 0) + 1;
    transaction.set(counterRef, {last_index: nextIndex}, {merge: true});
    const year = new Date().getFullYear();
    return `DESHMUKH-${year}-${String(nextIndex).padStart(3, "0")}`;
  });
}

async function syncClaims(uid, role, assignedClasses) {
  if (!uid) return;
  await getAuth().setCustomUserClaims(uid, {
    role: role || "Teacher",
    assigned_classes: Array.isArray(assignedClasses) ? assignedClasses : [],
  });
}

exports.beforecreated = beforeUserCreated(async (event) => {
  const email = String(event.data.email || "").trim().toLowerCase();
  if (!email) {
    throw new HttpsError("invalid-argument", "Email is required.");
  }
  const invite = await getFirestore().collection("pending_invites").doc(email).get();
  if (!invite.exists) {
    throw new HttpsError(
      "permission-denied",
      "Public sign-up is disabled. Ask an administrator to create your account.",
    );
  }
});

exports.createStaffUser = onCall(async (request) => {
  requireAuth(request);

  const db = getFirestore();
  const auth = getAuth();
  const callerRole = await getCallerRole(request.auth.uid);
  requireManager(callerRole);

  const data = request.data || {};
  const email = String(data.email || "").trim().toLowerCase();
  const password = String(data.password || "");
  const displayName = String(data.displayName || "").trim();
  const role = String(data.role || "").trim();
  const designation = String(data.designation || "").trim();
  const phoneNumber = String(data.phoneNumber || "").trim();
  const subjectExpertise = String(data.subjectExpertise || "").trim();
  const assignedClasses = parseAssignedClasses(data.assignedClasses);
  let employeeId = String(data.employeeId || "").trim();

  if (!email || !displayName || !role) {
    throw new HttpsError("invalid-argument", "email, displayName, and role are required.");
  }
  if (!ALLOWED_ROLES.includes(role)) {
    throw new HttpsError("invalid-argument", `Invalid role: ${role}`);
  }
  if (role === "Admin" && callerRole !== "Admin") {
    throw new HttpsError("permission-denied", "Only Admins can create Admin users.");
  }

  const existingQuery = await db.collection("users").where("email", "==", email).limit(1).get();
  let uid = existingQuery.empty ? null : existingQuery.docs[0].data()?.uid || existingQuery.docs[0].id;

  if (!uid) {
    if (password.length < 6) {
      throw new HttpsError("invalid-argument", "Password must be at least 6 characters.");
    }
    const inviteRef = db.collection("pending_invites").doc(email);
    await inviteRef.set({
      createdBy: request.auth.uid,
      role,
      createdAt: FieldValue.serverTimestamp(),
    });
    try {
      const userRecord = await auth.createUser({
        email,
        password,
        displayName,
        emailVerified: false,
        disabled: false,
      });
      uid = userRecord.uid;
    } catch (error) {
      if (error.code === "auth/email-already-exists") {
        const existing = await auth.getUserByEmail(email);
        uid = existing.uid;
      } else {
        throw new HttpsError("internal", error.message || "Failed to create auth user.");
      }
    } finally {
      await inviteRef.delete().catch(() => {});
    }
  }

  if (!employeeId) {
    employeeId = await getNextEmployeeId(db);
  }

  await syncClaims(uid, role, assignedClasses);

  const userData = {
    uid,
    email,
    display_name: displayName,
    role,
    designation,
    phone_number: phoneNumber,
    employee_id: employeeId,
    subject_expertise: subjectExpertise,
    assigned_classes: assignedClasses,
    updated_time: FieldValue.serverTimestamp(),
    notifications_enabled: true,
    is_pre_provisioned: false,
  };

  const userRef = db.collection("users").doc(uid);
  const existingDoc = await userRef.get();
  if (!existingDoc.exists) {
    userData.created_time = FieldValue.serverTimestamp();
    await userRef.set(userData);
  } else {
    await userRef.set(userData, {merge: true});
  }

  if (!existingQuery.empty && existingQuery.docs[0].id !== uid) {
    await existingQuery.docs[0].ref.delete();
  }

  return {uid, employeeId};
});

exports.backfillUserClaims = onCall(async (request) => {
  requireAuth(request);
  const callerRole = await getCallerRole(request.auth.uid);
  requireManager(callerRole);

  const snap = await getFirestore().collection("users").get();
  let updated = 0;
  const errors = [];
  for (const doc of snap.docs) {
    const data = doc.data() || {};
    const uid = data.uid || doc.id;
    try {
      await syncClaims(uid, data.role, parseAssignedClasses(data.assigned_classes));
      updated += 1;
    } catch (error) {
      errors.push({uid, message: error.message});
    }
  }
  return {updated, errors};
});

exports.sendWhatsAppMessage = onCall(async (request) => {
  requireAuth(request);
  const callerRole = await getCallerRole(request.auth.uid);
  if (!MANAGER_ROLES.includes(callerRole) && callerRole !== "Teacher") {
    throw new HttpsError("permission-denied", "Only staff can send WhatsApp messages.");
  }

  const token = process.env.WHATSAPP_ACCESS_TOKEN || "";
  const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID || "";
  if (!token || !phoneNumberId) {
    throw new HttpsError(
      "failed-precondition",
      "WhatsApp is not configured. Set WHATSAPP_ACCESS_TOKEN and WHATSAPP_PHONE_NUMBER_ID on the function.",
    );
  }

  const payload = request.data || {};
  const to = String(payload.to || "").replace(/\D/g, "");
  const type = String(payload.type || "text");
  if (!to) {
    throw new HttpsError("invalid-argument", "Recipient phone is required.");
  }

  let body;
  if (type === "template") {
    const templateName = String(payload.templateName || "").trim();
    if (!templateName) {
      throw new HttpsError("invalid-argument", "templateName is required.");
    }
    const parameters = Array.isArray(payload.parameters) ? payload.parameters : [];
    body = {
      messaging_product: "whatsapp",
      to,
      type: "template",
      template: {
        name: templateName,
        language: {code: payload.languageCode || "en_US"},
        components: parameters.length
          ? [{
            type: "body",
            parameters: parameters.map((text) => ({type: "text", text: String(text)})),
          }]
          : [],
      },
    };
  } else {
    const message = String(payload.message || "").trim();
    if (!message) {
      throw new HttpsError("invalid-argument", "message is required.");
    }
    body = {
      messaging_product: "whatsapp",
      recipient_type: "individual",
      to,
      type: "text",
      text: {preview_url: false, body: message},
    };
  }

  const response = await fetch(
    `https://graph.facebook.com/v17.0/${phoneNumberId}/messages`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    },
  );
  if (!response.ok) {
    const detail = await response.text();
    throw new HttpsError("internal", `WhatsApp API error: ${detail}`);
  }
  return {ok: true};
});

exports.syncUserRoleClaims = onDocumentWritten("users/{uid}", async (event) => {
  const uid = event.params.uid;
  const after = event.data?.after;
  if (!after?.exists) {
    try {
      await getAuth().setCustomUserClaims(uid, {});
    } catch (error) {
      console.warn("Could not clear claims for deleted user", uid, error.message);
    }
    return;
  }
  const data = after.data() || {};
  await syncClaims(uid, data.role, parseAssignedClasses(data.assigned_classes));
});
