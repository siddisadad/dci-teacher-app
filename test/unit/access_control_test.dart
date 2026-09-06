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

    test('only admins can create admin accounts', () {
      expect(AccessControl(_user('Admin')).canCreateAdmins, isTrue);
      expect(AccessControl(_user('Director')).canCreateAdmins, isFalse);
      expect(AccessControl(_user('Teacher')).canCreateAdmins, isFalse);
    });

    test('assigned classes restrict teachers but not managers', () {
      final restricted = AccessControl(
        _user('Teacher').copyWith(assignedClasses: ['10A', '10B']),
      );
      expect(restricted.hasClassRestriction, isTrue);
      expect(restricted.canAccessClass('10A'), isTrue);
      expect(restricted.canAccessClass('10C'), isFalse);

      final unassignedTeacher = AccessControl(_user('Teacher'));
      expect(unassignedTeacher.hasClassRestriction, isTrue);
      expect(unassignedTeacher.canAccessClass('10C'), isFalse);

      final admin = AccessControl(
        _user('Admin').copyWith(assignedClasses: ['10A']),
      );
      expect(admin.hasClassRestriction, isFalse);
      expect(admin.canAccessClass('10C'), isTrue);
    });

    test('parseClassList splits comma-separated class names', () {
      expect(Teacher.parseClassList('10A, 10B ,'), ['10A', '10B']);
      expect(Teacher.parseClassList(''), isEmpty);
      expect(Teacher.parseClassList(null), isEmpty);
    });
  });
}
