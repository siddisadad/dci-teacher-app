# DCI Teacher App

Official teacher application for Deshmukh Coaching Institute. Flutter client with Cloud Firestore, Firebase Auth, Storage, Messaging, and Cloud Functions.

## Features

- Role-based access: Director, Admin, Teacher, Student
- Student records, attendance, exams, marks, homework, daily reports
- Faculty management (Admin/Director)
- PDF report cards and Excel import/export

## Prerequisites

- Flutter **3.47.0** (pinned in CI)
- A Firebase project with Authentication (Email/Password), Firestore, Storage, and Cloud Functions (Blaze)
- Firebase CLI (`npm i -g firebase-tools`)

## Local setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Android and iOS Firebase config files (`google-services.json`, `GoogleService-Info.plist`) are already in the repo.

Public legal pages live in `firebase/public/` and deploy to Firebase Hosting on pushes to `main` when `FIREBASE_SERVICE_ACCOUNT_JSON` is set:

- Privacy Policy: https://d-c-i-teacher-app-lffjyu.web.app/privacy.html
- Terms of Service: https://d-c-i-teacher-app-lffjyu.web.app/tos.html

## Security deploy (required)

This branch tightens Firestore/Storage rules, blocks public Auth sign-up, and moves staff-user creation and WhatsApp Cloud API sends to Cloud Functions. Deploy them before using Add User or WhatsApp Cloud sends:

```bash
cd firebase
npm --prefix functions install
firebase deploy --only firestore:rules,firestore:indexes,storage,functions
```

Then in the Firebase console:

1. **Authentication → Settings**: keep Email/Password **sign-in** enabled. Public sign-up is blocked by `beforeUserCreated` unless `pending_invites/{email}` exists (written by `createStaffUser`).
2. Enable **Identity Platform** / Auth blocking functions if deploy of `beforecreated` fails. Without that, the blocking function will not run.
3. Confirm Firestore rules are the repo version (users cannot change their own `role` or `assigned_classes`).
4. Existing staff should **re-login** (or use Institute Settings → Backfill User Claims) so Auth tokens include `role` and `assigned_classes`.

### WhatsApp Cloud API

Device-share via `wa.me` does not need secrets. Cloud API sends go through the `sendWhatsAppMessage` callable. Set these environment variables / secrets on that function:

- `WHATSAPP_ACCESS_TOKEN`
- `WHATSAPP_PHONE_NUMBER_ID`

Do not put those values in the Flutter client.

## Roles

| Role | Students | Exams | Faculty | Settings |
| --- | --- | --- | --- | --- |
| Director | Manage | Manage | Manage (cannot create Admins) | Full |
| Admin | Manage | Manage | Manage | Limited |
| Teacher | View assigned classes / mark attendance / enter marks | Enter marks | Own profile | — |
| Student | Own record only | Own class exams / own results | — | — |

Teachers with a non-empty `assigned_classes` list can only read student records for those classes. An empty list keeps the previous unrestricted teacher view.

## Tests

```bash
flutter analyze
flutter test
cd firebase && npm --prefix tests ci && firebase emulators:exec --only firestore "npm --prefix tests test"
```

## CI/CD (GitHub Actions)

```
Developer → git push → GitHub
  → Flutter analyze + test
  → Signed Android AAB (+ APK)
  → Firebase App Distribution
  → Play Closed Testing (alpha)
  → Play production (git tags `v*` only)
```

Pull requests run analyze, tests, and Firestore rules tests only.

Pushes to `R1` / `main` / `dev` and `workflow_dispatch` also build a signed AAB when Android signing secrets are present. Firebase App Distribution uses the universal APK (AAB upload requires the Firebase project to already be linked to Play). Closed Testing uploads the AAB to the Play **alpha** track. Pushing a `v*` tag also promotes that AAB to **production**.

### Required GitHub secrets

| Secret | Used for |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded upload keystore (`*.jks`) |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_PASSWORD` | Key password (defaults to store password) |
| `ANDROID_KEY_ALIAS` | Key alias (defaults to `upload`) |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Firebase / GCP service account with App Distribution Admin |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | Play Console service account with Release to production / closed tracks |

Optional repo variables: `FIREBASE_ANDROID_APP_ID`, `FIREBASE_TESTER_GROUPS` (omit until the Firebase testers group exists).

Create the `testers` group in Firebase App Distribution and invite testers there. The Play app `com.dciteacherapp` must already exist in Play Console, and the service account must be invited under Play Console → Users and permissions.

```bash
base64 -w0 android/app/upload-keystore.jks
```
