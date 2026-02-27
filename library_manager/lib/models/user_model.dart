enum UserRole { patron, staff, admin }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.patron:
        return 'patron';
      case UserRole.staff:
        return 'staff';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'staff':
        return UserRole.staff;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.patron;
    }
  }
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: UserRoleExtension.fromString(map['role'] as String? ?? 'patron'),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, name: $name, email: $email, role: ${role.value})';
}
