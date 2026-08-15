# Release Requirements: Deshmukh Coaching Institute App

This document contains all the metadata and asset requirements needed for the **Google Play Store** and **Android App Center**.

---

## 1. Technical Details
* **App Name**: Deshmukh Coaching Institute App
* **Package Name**: `com.dciteacherapp`
* **Version Name**: `1.0.5` (from `pubspec.yaml`; CI may bump the build number)
* **Version Code**: `7+` (CI uses `pubspec` build number + GitHub `run_number`)
* **Build Format**: `.aab` (Android App Bundle) for Play Closed Testing / production, `.apk` for Firebase App Distribution.

---

## 2. Store Listing Metadata
### Descriptions
* **Short Description (max 80 chars)**:
  > Premium faculty management suite for Deshmukh Coaching Institute.
* **Full Description**:
  > Elevate your classroom management with the official Deshmukh Coaching Institute App. Designed with a sophisticated and professional interface, this tool empowers faculty to:
  > • Effortlessly track student attendance with a high-density, efficient interface.
  > • Bulk-import student records via Excel for rapid class setup.
  > • Assign and manage homework digitally with attachment support.
  > • Monitor student academic progress with clean, intuitive dashboards.
  > 
  > Secure, modern, and built specifically for the professional needs of our institute.

### Classification
* **Category**: Education
* **Tags**: Teacher Tool, Education Management, Productivity, School.

---

## 3. Visual Assets (Mandatory)
| Asset | Dimensions | Format | Purpose |
| :--- | :--- | :--- | :--- |
| **App Icon** | 512 x 512 px | PNG (32-bit) | Displayed on the store page. |
| **Feature Graphic** | 1024 x 500 px | PNG/JPG | Banner at the top of the listing. |
| **Phone Screenshots** | min. 320px, max. 3840px | PNG/JPG | 4-8 screens (Dashboard, Attendance, Student List, Profile). |
| **Tablet (10")** | Optional but recommended | PNG/JPG | Use same as phone or specific layouts. |

---

## 4. Data Safety & Privacy
Google requires you to fill out a "Data Safety" form based on the following:
* **Data Collected**: 
  * Name & Email (App Functionality)
  * Phone Number (Account Management)
  * User Content (Student records, IDs, and grades managed by teachers)
* **Security Practices**:
  * Data is **encrypted in transit** (using Firebase HTTPS).
  * Users can request that their data be deleted.
* **Privacy Policy URL**: (You must host the content of `PRIVACY_POLICY.md` and provide the link here).

---

## 5. Contact Information
* **Support Email**: admin@deshmukhinstitute.com
* **Website**: (Your institute website)

---

## 6. Pre-Submission Checklist
- [ ] GitHub Actions `AAB → App Distribution → Play` job is green on `R1` (or run **workflow_dispatch**).
- [ ] Repository secrets for the upload keystore, Firebase App Distribution, and Play Console are set (see README CI/CD).
- [ ] Host the Privacy Policy on a public URL.
- [ ] Capture 4 high-quality screenshots from your device or emulator.
