/// Fields that a non-manager must never change on a user profile write.
class UserProfileWrite {
  static const protectedFields = [
    'role',
    'uid',
    'email',
    'employee_id',
    'is_pre_provisioned',
    'created_time',
  ];

  static Map<String, dynamic> sanitize({
    required Map<String, dynamic> data,
    required bool isManager,
  }) {
    if (isManager) return Map<String, dynamic>.from(data);
    final copy = Map<String, dynamic>.from(data);
    for (final key in protectedFields) {
      copy.remove(key);
    }
    return copy;
  }
}
