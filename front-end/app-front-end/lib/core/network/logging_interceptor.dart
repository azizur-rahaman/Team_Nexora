import 'dart:convert';
import 'package:http/http.dart' as http;

/// Logging interceptor for debugging HTTP requests and responses
class LoggingInterceptor {
  static const bool _enableLogging = true; // Set to false in production

  /// Log HTTP request
  static void logRequest(http.Request request) {
    if (!_enableLogging) return;

    print('┌────────────────────────────────────────────────────────');
    print('│ 📤 REQUEST: ${request.method} ${request.url}');
    print('├────────────────────────────────────────────────────────');
    
    // Log headers
    if (request.headers.isNotEmpty) {
      print('│ Headers:');
      request.headers.forEach((key, value) {
        // Hide sensitive information
        if (key.toLowerCase() == 'authorization') {
          print('│   $key: ${_maskToken(value)}');
        } else {
          print('│   $key: $value');
        }
      });
    }

    // Log body
    if (request.body.isNotEmpty) {
      try {
        final jsonBody = jsonDecode(request.body);
        final prettyJson = JsonEncoder.withIndent('  ').convert(jsonBody);
        print('│ Body:');
        prettyJson.split('\n').forEach((line) {
          print('│   $line');
        });
      } catch (e) {
        print('│ Body: ${request.body}');
      }
    }
    
    print('└────────────────────────────────────────────────────────');
  }

  /// Log HTTP response
  static void logResponse(http.Response response) {
    if (!_enableLogging) return;

    final statusCode = response.statusCode;
    final emoji = _getStatusEmoji(statusCode);

    print('┌────────────────────────────────────────────────────────');
    print('│ $emoji RESPONSE: ${response.request?.method} ${response.request?.url}');
    print('│ Status Code: $statusCode ${response.reasonPhrase ?? ''}');
    print('├────────────────────────────────────────────────────────');

    // Log headers
    if (response.headers.isNotEmpty) {
      print('│ Headers:');
      response.headers.forEach((key, value) {
        print('│   $key: $value');
      });
    }

    // Log body
    if (response.body.isNotEmpty) {
      try {
        final jsonBody = jsonDecode(response.body);
        final prettyJson = JsonEncoder.withIndent('  ').convert(jsonBody);
        print('│ Body:');
        prettyJson.split('\n').forEach((line) {
          print('│   $line');
        });
      } catch (e) {
        print('│ Body: ${response.body}');
      }
    }

    print('└────────────────────────────────────────────────────────');
  }

  /// Log HTTP error
  static void logError(Exception error) {
    if (!_enableLogging) return;

    print('┌────────────────────────────────────────────────────────');
    print('│ ❌ ERROR: $error');
    print('└────────────────────────────────────────────────────────');
  }

  /// Mask sensitive token for logging
  static String _maskToken(String token) {
    if (token.length <= 10) return '***';
    return '${token.substring(0, 10)}...${token.substring(token.length - 4)}';
  }

  /// Get emoji based on status code
  static String _getStatusEmoji(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return '✅'; // Success
    } else if (statusCode >= 300 && statusCode < 400) {
      return '↪️'; // Redirect
    } else if (statusCode >= 400 && statusCode < 500) {
      return '⚠️'; // Client error
    } else if (statusCode >= 500) {
      return '🔥'; // Server error
    }
    return '📥';
  }
}
