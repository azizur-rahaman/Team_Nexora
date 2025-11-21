import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
/// Manages all environment variables from .env file
class EnvConfig {
  /// Base URL for API requests
  static String get baseUrl => dotenv.env['BaseUrl'] ?? '';

  /// Check if environment is loaded
  static bool get isLoaded => dotenv.isEveryDefined(['BaseUrl']);

  /// Initialize environment variables
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
