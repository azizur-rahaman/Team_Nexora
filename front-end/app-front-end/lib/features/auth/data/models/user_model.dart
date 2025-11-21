import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.username,
    required super.email,
    required super.token,
    super.roles = const [],
  });

  /// Create UserModel from API JSON response
  /// Expected format:
  /// {
  ///   "token": "eyJhbGciOiJIUzM4NCJ9...",
  ///   "username": "string",
  ///   "email": "string",
  ///   "roles": []
  /// }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
  
  /// Create UserModel from entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      username: user.username,
      email: user.email,
      token: user.token,
      roles: user.roles,
    );
  }
}
