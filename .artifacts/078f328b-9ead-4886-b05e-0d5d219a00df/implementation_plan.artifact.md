# Final Project Cleanup & Resilience

This plan focuses on cleaning up the project environment and making the CI/CD pipeline even more resilient to common setup issues.

## User Review Required

> [!NOTE]
> I am adding `keystore-base64.txt` to `.gitignore` to prevent accidental commits of your encoded key. I am also fixing a few critical lint warnings to improve code health.

## Proposed Changes

### Project Configuration

#### [MODIFY] [.gitignore](file:///C:/Users/USER/StudioProjects/dci-teacher-app/.gitignore)
- Add `keystore-base64.txt` and other common sensitive text files to the ignore list.

### CI/CD Workflow

#### [MODIFY] [flutter_ci.yml](file:///C:/Users/USER/StudioProjects/dci-teacher-app/.github/workflows/flutter_ci.yml)
- Use `printf` instead of `echo` for base64 decoding to handle potential whitespace/newline issues in secrets.
- Add more descriptive error messages if specific signing secrets are missing (e.g., distinguishing between a missing keystore and missing passwords).
- Ensure the `Firebase App Distribution` step uses a fallback for release notes if the commit message is missing.

### Code Health

#### [MODIFY] [edit_profile_widget.dart](file:///C:/Users/USER/StudioProjects/dci-teacher-app/lib/pages/edit_profile/edit_profile_widget.dart)
- Remove unnecessary non-null assertions (!) as identified in the analysis.

## Verification Plan

### Automated Tests
- Push to `R1` to verify the updated workflow handles the secrets (once you add them) more robustly.
- Verify that `git status` no longer shows `keystore-base64.txt`.

### Manual Verification
- Check the "Actions" tab to see the improved error reporting if secrets are still missing.
