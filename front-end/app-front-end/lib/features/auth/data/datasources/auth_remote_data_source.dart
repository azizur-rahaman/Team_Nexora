import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls the http://api.example.com/login endpoint
  /// 
  /// Throws a [ServerException] for all error codes
  Future<UserModel> login(String email, String password);

  /// Calls the http://api.example.com/register endpoint
  /// 
  /// Throws a [ServerException] for all error codes
  Future<UserModel> register(String email, String password, String name);

  /// Logout the current user
  Future<void> logout();

  /// Get the current user
  Future<UserModel> getCurrentUser();
}
