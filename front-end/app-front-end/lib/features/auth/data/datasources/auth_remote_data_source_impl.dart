import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/token_storage.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Validate required fields
        if (jsonResponse['token'] == null || 
            jsonResponse['username'] == null || 
            jsonResponse['email'] == null) {
          throw ServerException(message: 'Invalid response format: missing required fields');
        }
        
        // Save token to secure storage
        await tokenStorage.saveToken(jsonResponse['token']);
        
        // Parse and return user model
        return UserModel.fromJson(jsonResponse);
      } catch (e) {
        if (e is ServerException) rethrow;
        throw ServerException(message: 'Failed to parse login response: ${e.toString()}');
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(message: 'Invalid credentials');
    } else if (response.statusCode == 400) {
      throw ValidationException(message: 'Invalid request data');
    } else {
      throw ServerException(message: 'Login failed with status: ${response.statusCode}');
    }
  }

  @override
  Future<UserModel> register(String username, String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.createUser}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'isActive': true,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        // If registration returns user with token, save it and return
        if (jsonResponse['token'] != null) {
          await tokenStorage.saveToken(jsonResponse['token']);
          return UserModel.fromJson(jsonResponse);
        }
        
        // If registration successful but no token, user needs to login
        // Return a temporary user model without token
        return UserModel(
          username: username,
          email: email,
          token: '',
          roles: [],
        );
      } catch (e) {
        if (e is ServerException) rethrow;
        throw ServerException(message: 'Failed to parse registration response: ${e.toString()}');
      }
    } else if (response.statusCode == 400) {
      throw ValidationException(message: 'Invalid registration data');
    } else if (response.statusCode == 409) {
      throw ValidationException(message: 'User already exists');
    } else {
      throw ServerException(message: 'Registration failed with status: ${response.statusCode}');
    }
  }

  @override
  Future<void> logout() async {
    // Clear stored tokens
    await tokenStorage.clearToken();
    
    // Optionally call logout endpoint if backend requires it
    try {
      await client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/auth/logout'),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      // Ignore logout endpoint errors, token is already cleared locally
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await client.get(
      Uri.parse('${ApiEndpoints.baseUrl}/api/auth/me'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
