import 'package:flutter_test/flutter_test.dart';
import 'package:d_c_i_teacher_app/backend/models/teacher.dart';
import 'package:d_c_i_teacher_app/core/services/access_control.dart';

Teacher _user(String role) => Teacher(
      uid: 'u1',
      email: 'user@dci.com',
      displayName: 'User',
      photoUrl: '',
      role: role,
      designation: '',
      phoneNumber: '',
    );

void main() {
  group('AccessControl', () {
    test('students cannot manage records or view other students', () {
      final access = AccessControl(_user('Student'));
      expect(access.isStudent, isTrue);
      expect(access.canViewStudents, isFalse);
      expect(access.canManageStudents, isFalse);
      expect(access.canManageTeachers, isFalse);
      expect(access.canEnterMarks, isFalse);
      expect(access.canMarkAttendance, isFalse);
    });

    test('teachers can mark attendance and enter marks but not manage faculty',
        () {
      final access = AccessControl(_user('Teacher'));
      expect(access.canMarkAttendance, isTrue);
      expect(access.canEnterMarks, isTrue);
      expect(access.canSubmitDailyReport, isTrue);
      expect(access.canManageStudents, isFalse);
      expect(access.canManageTeachers, isFalse);
      expect(access.canManageExams, isFalse);
    });

    test('admins and directors can manage faculty and students', () {
      for (final role in ['Admin', 'Director']) {
        final access = AccessControl(_user(role));
        expect(access.canManageTeachers, isTrue, reason: role);
        expect(access.canManageStudents, isTrue, reason: role);
        expect(access.canViewStudents, isTrue, reason: role);
      }
    });

    test('unknown or missing user is locked down', () {
      expect(AccessControl(null).canViewStudents, isFalse);
      expect(AccessControl(_user('')).canManageTeachers, isFalse);
    });
  });
}
