import 'package:http/http.dart' as http;

/// HTTP Client with Interceptor functionality
/// Wraps the standard http.Client to provide request/response interception
class HttpClientInterceptor extends http.BaseClient {
  final http.Client _inner;
  final TokenProvider? tokenProvider;
  final void Function(http.Request)? onRequest;
  final void Function(http.Response)? onResponse;
  final void Function(Exception)? onError;

  HttpClientInterceptor({
    required http.Client inner,
    this.tokenProvider,
    this.onRequest,
    this.onResponse,
    this.onError,
  }) : _inner = inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      // Add authentication token if available
      if (tokenProvider != null) {
        final token = await tokenProvider!.getToken();
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }

      // Add common headers
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      // Log request if callback is provided
      if (onRequest != null && request is http.Request) {
        onRequest!(request);
      }

      // Send the request
      final response = await _inner.send(request);

      // Convert StreamedResponse to Response for easier handling
      final responseBody = await response.stream.toBytes();
      final fullResponse = http.Response.bytes(
        responseBody,
        response.statusCode,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );

      // Log response if callback is provided
      if (onResponse != null) {
        onResponse!(fullResponse);
      }

      // Handle unauthorized responses
      if (response.statusCode == 401) {
        // Token might be expired, clear it
        await tokenProvider?.clearToken();
      }

      // Convert back to StreamedResponse
      return http.StreamedResponse(
        http.ByteStream.fromBytes(responseBody),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      if (onError != null && e is Exception) {
        onError!(e);
      }
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}

/// Token provider interface
abstract class TokenProvider {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}
