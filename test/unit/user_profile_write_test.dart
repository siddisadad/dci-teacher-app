import 'package:flutter_test/flutter_test.dart';
import 'package:d_c_i_teacher_app/backend/services/user_profile_write.dart';

void main() {
  group('UserProfileWrite.sanitize', () {
    final payload = {
      'uid': 'abc',
      'email': 'teacher@dci.com',
      'display_name': 'Patil',
      'role': 'Admin',
      'employee_id': 'DESHMUKH-2026-001',
      'is_pre_provisioned': true,
      'created_time': 'keep',
      'phone_number': '9876543210',
    };

    test('managers keep privileged fields', () {
      final result = UserProfileWrite.sanitize(data: payload, isManager: true);
      expect(result['role'], 'Admin');
      expect(result['email'], 'teacher@dci.com');
      expect(result['employee_id'], 'DESHMUKH-2026-001');
      expect(result['phone_number'], '9876543210');
    });

    test('non-managers cannot change role or identity fields', () {
      final result = UserProfileWrite.sanitize(data: payload, isManager: false);
      expect(result.containsKey('role'), isFalse);
      expect(result.containsKey('uid'), isFalse);
      expect(result.containsKey('email'), isFalse);
      expect(result.containsKey('employee_id'), isFalse);
      expect(result.containsKey('is_pre_provisioned'), isFalse);
      expect(result.containsKey('created_time'), isFalse);
      expect(result['display_name'], 'Patil');
      expect(result['phone_number'], '9876543210');
    });
  });
}
