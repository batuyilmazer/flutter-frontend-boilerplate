import '../errors/app_exception.dart';
import '../../features/auth/data/auth_repository.dart';

/// Interceptor for automatic token injection and refresh on 401 errors.
///
/// This interceptor:
/// 1. Automatically adds `Authorization: Bearer <token>` header to requests
/// 2. Intercepts 401 responses and attempts token refresh
/// 3. Retries the original request with new token if refresh succeeds
class AuthInterceptor {
  AuthInterceptor({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// Intercept request headers to add authorization token.
  ///
  /// Returns modified headers with Authorization header if token exists.
  Future<Map<String, String>> interceptRequest(
    Map<String, String>? headers,
  ) async {
    final accessToken = await _authRepository.getAccessToken();
    if (accessToken == null) {
      return headers ?? {};
    }

    final modifiedHeaders = Map<String, String>.from(headers ?? {});
    modifiedHeaders['Authorization'] = 'Bearer $accessToken';
    return modifiedHeaders;
  }

  /// Intercept response to handle 401 errors with automatic token refresh.
  ///
  /// Attempts to refresh token and retry the request.
  /// Returns the response if successful, throws exception if refresh fails.
  Future<Map<String, dynamic>> interceptResponse(
    Future<Map<String, dynamic>> Function() requestFn,
  ) async {
    // Try to refresh token
    try {
      await _authRepository.refreshAccessToken();
      // Retry original request with new token
      return await requestFn();
    } catch (e) {
      // Refresh failed - user needs to login again
      throw ApiException(
        statusCode: 401,
        message: 'Session expired. Please login again.',
      );
    }
  }
}

