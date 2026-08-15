# DCI Teacher App

Official teacher application for Deshmukh Coaching Institute. Flutter client with Cloud Firestore, Firebase Auth, Storage, Messaging, and Cloud Functions.

## Features

- Role-based access: Director, Admin, Teacher, Student
- Student records, attendance, exams, marks, homework, daily reports
- Faculty management (Admin/Director)
- PDF report cards and Excel import/export

## Prerequisites

- Flutter stable (Dart 3)
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

This branch tightens Firestore/Storage rules and moves staff-user creation to Cloud Functions. Deploy them before using the Add User screen:

```bash
cd firebase
npm --prefix functions install
firebase deploy --only firestore:rules,firestore:indexes,storage,functions
```

Then in the Firebase console:

1. **Authentication → Settings**: keep Email/Password **sign-in** enabled. There is no public sign-up screen; new accounts must be created by Admin/Director via `createStaffUser`.
2. Confirm Firestore rules are the repo version (users cannot change their own `role`).

## Roles

| Role | Students | Exams | Faculty | Settings |
| --- | --- | --- | --- | --- |
| Director | Manage | Manage | Manage | Full |
| Admin | Manage | Manage | Manage | Limited |
| Teacher | View / mark attendance / enter marks | Enter marks | Own profile | — |
| Student | Own record only | Own results | — | — |

## Tests

```bash
flutter analyze
flutter test
```

## WhatsApp

Device-share via `wa.me` does not need secrets. Cloud API sends are **disabled** unless you pass compile-time defines (not recommended in the client). Prefer a Cloud Function with Secret Manager for production messaging.
