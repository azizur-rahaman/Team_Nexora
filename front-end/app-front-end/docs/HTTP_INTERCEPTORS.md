# HTTP Interceptors Implementation

This document explains the HTTP interceptor implementation in the FoodFlow app.

## Overview

The app uses a custom HTTP client interceptor system to handle:
- **Authentication**: Automatically adds JWT tokens to requests
- **Logging**: Logs all HTTP requests and responses for debugging
- **Token Management**: Stores and retrieves authentication tokens
- **Error Handling**: Centralized error handling for HTTP requests

## Components

### 1. HttpClientInterceptor
Located: `lib/core/network/http_client_interceptor.dart`

Main interceptor that wraps the standard `http.Client` to provide request/response interception.

**Features:**
- Automatically adds Authorization header with JWT token
- Adds common headers (Content-Type, Accept)
- Calls callbacks for request, response, and error logging
- Handles 401 unauthorized responses by clearing tokens

### 2. TokenStorage
Located: `lib/core/network/token_storage.dart`

Manages authentication token persistence using SharedPreferences.

**Features:**
- Save/retrieve access tokens
- Save/retrieve refresh tokens
- Clear all tokens on logout
- Check authentication status

**Usage:**
```dart
// Get token
final token = await tokenStorage.getToken();

// Save tokens
await tokenStorage.saveTokens(
  accessToken: 'your-access-token',
  refreshToken: 'your-refresh-token',
);

// Clear tokens
await tokenStorage.clearToken();

// Check if authenticated
final isAuth = await tokenStorage.isAuthenticated();
```

### 3. LoggingInterceptor
Located: `lib/core/network/logging_interceptor.dart`

Provides formatted console logging for HTTP requests and responses.

**Features:**
- Pretty-printed JSON bodies
- Color-coded status indicators
- Masks sensitive information (tokens)
- Can be disabled in production

**Output Example:**
```
┌────────────────────────────────────────────────────────
│ 📤 REQUEST: POST https://api.example.com/auth/login
├────────────────────────────────────────────────────────
│ Headers:
│   Content-Type: application/json
│   Accept: application/json
│ Body:
│   {
│     "email": "user@example.com",
│     "password": "******"
│   }
└────────────────────────────────────────────────────────

┌────────────────────────────────────────────────────────
│ ✅ RESPONSE: POST https://api.example.com/auth/login
│ Status Code: 200 OK
├────────────────────────────────────────────────────────
│ Body:
│   {
│     "token": "eyJhbGciOi...",
│     "user": {
│       "id": "123",
│       "email": "user@example.com"
│     }
│   }
└────────────────────────────────────────────────────────
```

## Setup

The interceptors are configured in `injection_container.dart`:

```dart
// Token Storage
sl.registerLazySingleton<TokenProvider>(
  () => TokenStorage(sharedPreferences: sl()),
);

// HTTP Client with interceptors
sl.registerLazySingleton<http.Client>(
  () => HttpClientInterceptor(
    inner: http.Client(),
    tokenProvider: sl<TokenProvider>(),
    onRequest: LoggingInterceptor.logRequest,
    onResponse: LoggingInterceptor.logResponse,
    onError: LoggingInterceptor.logError,
  ),
);
```

## Authentication Flow

### Login/Registration
1. User submits credentials
2. Request sent to API (logged by interceptor)
3. Response received with token
4. Token automatically saved to SharedPreferences
5. Subsequent requests include token in Authorization header

### Authenticated Requests
1. HttpClientInterceptor checks for stored token
2. If token exists, adds `Authorization: Bearer <token>` header
3. Request proceeds normally
4. If 401 response received, token is cleared (user needs to login again)

### Logout
1. Logout endpoint called (optional)
2. Tokens cleared from SharedPreferences
3. Authorization header no longer included in subsequent requests

## Token Response Format

The interceptor expects tokens in the API response:

**Login/Registration Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "optional-refresh-token",
  "user": {
    "id": "user-id",
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

## Error Handling

The interceptor handles errors at multiple levels:

1. **Network Errors**: Logged via `onError` callback
2. **401 Unauthorized**: Token automatically cleared
3. **4xx/5xx Errors**: Logged with response details

## Additional Interceptor Examples

Located: `lib/core/network/interceptor_examples.dart`

Additional interceptor patterns for:
- **RetryInterceptor**: Auto-retry failed requests
- **TimeoutInterceptor**: Add timeouts to requests
- **CacheInterceptor**: Simple response caching
- **ErrorHandlerInterceptor**: Centralized error handling

## Configuration

### Disable Logging in Production

In `logging_interceptor.dart`:
```dart
static const bool _enableLogging = false; // Set to false for production
```

### Customize Token Header

In `http_client_interceptor.dart`:
```dart
request.headers['Authorization'] = 'Bearer $token'; // Modify as needed
```

### Add Custom Headers

```dart
// Add in http_client_interceptor.dart send() method
request.headers['X-App-Version'] = '1.0.0';
request.headers['X-Platform'] = 'mobile';
```

## Testing

The interceptor is automatically injected through GetIt, making it easy to mock in tests:

```dart
// In test setup
sl.registerLazySingleton<http.Client>(
  () => MockHttpClient(),
);
```

## Security Considerations

1. **Token Storage**: Tokens are stored in SharedPreferences (secure on iOS/Android)
2. **Logging**: Sensitive data (passwords, full tokens) are masked in logs
3. **HTTPS**: Always use HTTPS endpoints in production
4. **Token Expiry**: Backend should implement token expiration
5. **Refresh Tokens**: Implement token refresh logic for better UX

## Future Improvements

- Implement automatic token refresh
- Add request queuing for offline scenarios
- Implement certificate pinning
- Add request/response encryption for sensitive data
- Rate limiting and throttling
