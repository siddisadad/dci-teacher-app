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
