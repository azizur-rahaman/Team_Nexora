import '../config/env_config.dart';

class ApiEndpoints {
  static String get baseUrl => EnvConfig.baseUrl;
  static const String createUser = '/User/add';
}