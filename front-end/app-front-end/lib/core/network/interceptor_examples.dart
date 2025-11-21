import 'package:http/http.dart' as http;

/// Example of custom interceptor for specific use cases
/// You can create different interceptors for different purposes

/// Retry Interceptor - Automatically retries failed requests
class RetryInterceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  Future<http.Response> executeWithRetry(
    Future<http.Response> Function() request,
  ) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        final response = await request();
        
        // Only retry on specific status codes
        if (response.statusCode >= 500 || response.statusCode == 408) {
          attempts++;
          if (attempts < maxRetries) {
            await Future.delayed(retryDelay * attempts);
            continue;
          }
        }
        
        return response;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(retryDelay * attempts);
      }
    }
    
    throw Exception('Max retries exceeded');
  }
}

/// Timeout Interceptor - Adds timeout to requests
class TimeoutInterceptor {
  final Duration timeout;

  TimeoutInterceptor({
    this.timeout = const Duration(seconds: 30),
  });

  Future<T> executeWithTimeout<T>(Future<T> Function() request) async {
    return await request().timeout(
      timeout,
      onTimeout: () {
        throw Exception('Request timeout after ${timeout.inSeconds} seconds');
      },
    );
  }
}

/// Cache Interceptor - Simple response caching
class CacheInterceptor {
  final Map<String, CachedResponse> _cache = {};
  final Duration cacheDuration;

  CacheInterceptor({
    this.cacheDuration = const Duration(minutes: 5),
  });

  Future<http.Response?> getCachedResponse(String key) async {
    final cached = _cache[key];
    if (cached != null && !cached.isExpired) {
      return cached.response;
    }
    _cache.remove(key);
    return null;
  }

  void cacheResponse(String key, http.Response response) {
    _cache[key] = CachedResponse(
      response: response,
      timestamp: DateTime.now(),
      duration: cacheDuration,
    );
  }

  void clearCache() {
    _cache.clear();
  }
}

class CachedResponse {
  final http.Response response;
  final DateTime timestamp;
  final Duration duration;

  CachedResponse({
    required this.response,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired =>
      DateTime.now().difference(timestamp) > duration;
}

/// Error Handler Interceptor - Centralized error handling
class ErrorHandlerInterceptor {
  final void Function(int statusCode, String message)? onClientError;
  final void Function(int statusCode, String message)? onServerError;
  final void Function(Exception error)? onNetworkError;

  ErrorHandlerInterceptor({
    this.onClientError,
    this.onServerError,
    this.onNetworkError,
  });

  void handleResponse(http.Response response) {
    if (response.statusCode >= 400 && response.statusCode < 500) {
      onClientError?.call(response.statusCode, response.body);
    } else if (response.statusCode >= 500) {
      onServerError?.call(response.statusCode, response.body);
    }
  }

  void handleError(Exception error) {
    onNetworkError?.call(error);
  }
}
