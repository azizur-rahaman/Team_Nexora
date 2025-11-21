import 'package:shared_preferences/shared_preferences.dart';
import 'http_client_interceptor.dart';

/// Token storage implementation using SharedPreferences
class TokenStorage implements TokenProvider {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  TokenStorage({required this.sharedPreferences});

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_refreshTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(_refreshTokenKey);
  }

  /// Save both access and refresh tokens
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveToken(accessToken);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
