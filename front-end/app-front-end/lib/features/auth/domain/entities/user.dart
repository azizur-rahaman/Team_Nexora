import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String email;
  final String token;
  final List<String> roles;

  const User({
    required this.username,
    required this.email,
    required this.token,
    this.roles = const [],
  });

  @override
  List<Object?> get props => [username, email, token, roles];
  
  /// Get display name (username)
  String get displayName => username;
  
  /// Check if user has a specific role
  bool hasRole(String role) => roles.contains(role);
  
  /// Check if user is authenticated (has a token)
  bool get isAuthenticated => token.isNotEmpty;
}
