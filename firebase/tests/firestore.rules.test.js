const {readFileSync} = require("fs");
const {resolve} = require("path");
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require("@firebase/rules-unit-testing");

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: "dci-rules-test",
    firestore: {
      rules: readFileSync(resolve(__dirname, "../firestore.rules"), "utf8"),
      host: "127.0.0.1",
      port: 8080,
    },
  });
});

after(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

async function seed(docs) {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    for (const [path, data] of Object.entries(docs)) {
      await db.doc(path).set(data);
    }
  });
}

function authed(uid, claims) {
  return testEnv.authenticatedContext(uid, claims).firestore();
}

describe("Firestore rules", () => {
  it("denies unauthenticated student reads", async () => {
    await seed({"students/stu1": {class: "10A", name: "A"}});
    const db = testEnv.unauthenticatedContext().firestore();
    await assertFails(db.doc("students/stu1").get());
  });

  it("lets a student read only their own student doc", async () => {
    await seed({
      "students/stu1": {class: "10A", name: "A"},
      "students/stu2": {class: "10A", name: "B"},
    });
    const db = authed("stu1", {role: "Student"});
    await assertSucceeds(db.doc("students/stu1").get());
    await assertFails(db.doc("students/stu2").get());
    await assertFails(db.collection("students").get());
  });

  it("lets unrestricted teachers list all students", async () => {
    await seed({
      "users/t1": {role: "Teacher", assigned_classes: []},
      "students/stu1": {class: "10A", name: "A"},
      "students/stu2": {class: "10B", name: "B"},
    });
    const db = authed("t1", {role: "Teacher", assigned_classes: []});
    await assertSucceeds(db.collection("students").get());
  });

  it("scopes assigned teachers to their classes", async () => {
    await seed({
      "users/t1": {role: "Teacher", assigned_classes: ["10A"]},
      "students/stu1": {class: "10A", name: "A"},
      "students/stu2": {class: "10B", name: "B"},
    });
    const db = authed("t1", {role: "Teacher", assigned_classes: ["10A"]});
    await assertSucceeds(db.doc("students/stu1").get());
    await assertFails(db.doc("students/stu2").get());
    await assertFails(db.collection("students").get());
    await assertSucceeds(
        db.collection("students").where("class", "==", "10A").get(),
    );
  });

  it("lets managers read every student", async () => {
    await seed({
      "students/stu1": {class: "10A", name: "A"},
      "students/stu2": {class: "10B", name: "B"},
    });
    const db = authed("admin1", {role: "Admin"});
    await assertSucceeds(db.collection("students").get());
  });

  it("blocks teachers from changing their role or assigned classes", async () => {
    await seed({
      "users/t1": {
        role: "Teacher",
        uid: "t1",
        email: "t@dci.com",
        assigned_classes: ["10A"],
      },
    });
    const db = authed("t1", {role: "Teacher", assigned_classes: ["10A"]});
    await assertFails(db.doc("users/t1").update({role: "Admin"}));
    await assertFails(db.doc("users/t1").update({assigned_classes: ["10B"]}));
    await assertSucceeds(db.doc("users/t1").update({phone_number: "1"}));
  });

  it("lets students read published homework for their class only", async () => {
    await seed({
      "students/stu1": {class: "10A", name: "A"},
      "homework_assignments/hw1": {class: "10A", status: "published"},
      "homework_assignments/hw2": {class: "10B", status: "published"},
      "homework_assignments/hw3": {class: "10A", status: "draft"},
    });
    const db = authed("stu1", {role: "Student"});
    await assertSucceeds(db.doc("homework_assignments/hw1").get());
    await assertFails(db.doc("homework_assignments/hw2").get());
    await assertFails(db.doc("homework_assignments/hw3").get());
  });

  it("lets students read exams for their class only", async () => {
    await seed({
      "students/stu1": {class: "10A", name: "A"},
      "exams/e1": {class: "10A"},
      "exams/e2": {class: "10B"},
    });
    const db = authed("stu1", {role: "Student"});
    await assertSucceeds(db.doc("exams/e1").get());
    await assertFails(db.doc("exams/e2").get());
  });

  it("denies all client access to pending_invites", async () => {
    await seed({"pending_invites/a@dci.com": {role: "Teacher"}});
    const adminDb = authed("admin1", {role: "Admin"});
    await assertFails(adminDb.doc("pending_invites/a@dci.com").get());
    await assertFails(adminDb.doc("pending_invites/a@dci.com").set({role: "Admin"}));
  });
});
