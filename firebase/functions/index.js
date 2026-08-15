const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

initializeApp();

const MANAGER_ROLES = ["Admin", "Director"];
const ALLOWED_ROLES = ["Admin", "Director", "Teacher", "Student"];

function requireManager(callerRole) {
  if (!MANAGER_ROLES.includes(callerRole)) {
    throw new HttpsError(
      "permission-denied",
      "Only Admin or Director can create staff users.",
    );
  }
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

async function syncClaims(uid, role) {
  if (!uid) return;
  await getAuth().setCustomUserClaims(uid, {role: role || "Teacher"});
}

exports.createStaffUser = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }

  const db = getFirestore();
  const auth = getAuth();
  const callerSnap = await db.collection("users").doc(request.auth.uid).get();
  requireManager(callerSnap.data()?.role);

  const data = request.data || {};
  const email = String(data.email || "").trim().toLowerCase();
  const password = String(data.password || "");
  const displayName = String(data.displayName || "").trim();
  const role = String(data.role || "").trim();
  const designation = String(data.designation || "").trim();
  const phoneNumber = String(data.phoneNumber || "").trim();
  const subjectExpertise = String(data.subjectExpertise || "").trim();
  let employeeId = String(data.employeeId || "").trim();

  if (!email || !displayName || !role) {
    throw new HttpsError("invalid-argument", "email, displayName, and role are required.");
  }
  if (!ALLOWED_ROLES.includes(role)) {
    throw new HttpsError("invalid-argument", `Invalid role: ${role}`);
  }

  const existingQuery = await db.collection("users").where("email", "==", email).limit(1).get();
  let uid = existingQuery.empty ? null : existingQuery.docs[0].data()?.uid || existingQuery.docs[0].id;

  if (!uid) {
    if (password.length < 6) {
      throw new HttpsError("invalid-argument", "Password must be at least 6 characters.");
    }
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
    }
  }

  if (!employeeId) {
    employeeId = await getNextEmployeeId(db);
  }

  await syncClaims(uid, role);

  const userData = {
    uid,
    email,
    display_name: displayName,
    role,
    designation,
    phone_number: phoneNumber,
    employee_id: employeeId,
    subject_expertise: subjectExpertise,
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
  const role = after.data()?.role || "Teacher";
  await syncClaims(uid, role);
});
