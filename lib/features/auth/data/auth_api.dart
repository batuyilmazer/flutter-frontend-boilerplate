import '../../../core/models/session.dart';
import '../../../core/models/user/models.dart';
import '../../../core/network/api_client.dart';

/// Response model for register/login endpoints.
class AuthResponse {
  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.session,
  });

  final User user;
  final String accessToken;
  final Session session;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access'] as String,
      session: Session.fromJson(json['session'] as Map<String, dynamic>),
    );
  }
}

/// Response model for refresh token endpoint.
class RefreshResponse {
  const RefreshResponse({
    required this.newRefreshToken,
    required this.accessToken,
  });

  final String newRefreshToken;
  final String accessToken;

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      newRefreshToken: json['newRaw'] as String,
      accessToken: json['access'] as String,
    );
  }
}

/// Low-level API client for authentication endpoints.
///
/// This class directly calls backend endpoints and returns raw response data.
/// Use [AuthRepository] for higher-level operations that handle storage.
class AuthApi {
  AuthApi({ApiClient? apiClient}) : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  /// Register a new user.
  ///
  /// POST /auth/register
  /// Body: {email: string, password: string}
  /// Returns: AuthResponse with user, accessToken, and session
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    final response = await _client.postJson(
      '/auth/register',
      body: {'email': email, 'password': password},
    );
    return AuthResponse.fromJson(response);
  }

  /// Login with email and password.
  ///
  /// POST /auth/login
  /// Body: {email: string, password: string, deviceId?: string}
  /// Returns: AuthResponse with user, accessToken, and session
  Future<AuthResponse> login({
    required String email,
    required String password,
    String? deviceId,
  }) async {
    final body = <String, dynamic>{'email': email, 'password': password};
    if (deviceId != null) {
      body['deviceId'] = deviceId;
    }

    final response = await _client.postJson('/auth/login', body: body);
    return AuthResponse.fromJson(response);
  }

  /// Refresh access token using refresh token.
  ///
  /// POST /auth/refresh
  /// Body: {refreshToken: string, deviceId: string}
  /// Returns: RefreshResponse with new refresh token and access token
  Future<RefreshResponse> refresh({
    required String refreshToken,
    required String deviceId,
  }) async {
    final response = await _client.postJson(
      '/auth/refresh',
      body: {'refreshToken': refreshToken, 'deviceId': deviceId},
    );
    return RefreshResponse.fromJson(response);
  }

  /// Logout current session.
  ///
  /// POST /auth/logout
  /// Body: {refreshToken: string}
  /// Returns: {msg: string}
  Future<void> logout(String refreshToken) async {
    await _client.postJson(
      '/auth/logout',
      body: {'refreshToken': refreshToken},
    );
  }

  /// Logout from all devices.
  ///
  /// POST /auth/logout-all
  /// Headers: Authorization: Bearer `accessToken`
  /// Returns: {msg: string}
  Future<void> logoutAll(String accessToken) async {
    await _client.postJson(
      '/auth/logout-all',
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }

  /// Get current user info.
  ///
  /// GET /me
  /// Headers: Authorization: Bearer `accessToken`
  /// Returns: {user: User, sessions: [...]}
  /// Note: Backend returns user and sessions, but we only extract user for now
  Future<User> getMe(String accessToken) async {
    final response = await _client.getJson(
      '/me',
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    // Backend returns {user: {...}, sessions: [...]}
    return User.fromJson(response['user'] as Map<String, dynamic>);
  }

  /// Send 2FA verification email.
  ///
  /// POST /auth/2fa
  /// Headers: Authorization: Bearer `accessToken`
  /// Body: {scope: "reset-password" | "verify-email"}
  /// Returns: {msg: string}
  Future<void> sendTwoFa({
    required String accessToken,
    required String scope, // "reset-password" | "verify-email"
  }) async {
    await _client.postJson(
      '/auth/2fa',
      headers: {'Authorization': 'Bearer $accessToken'},
      body: {'scope': scope},
    );
  }

  /// Verify email address using 2FA token.
  ///
  /// POST /auth/verify-email
  /// Headers: Authorization: Bearer `accessToken`, X-2FA-Token: `token`
  /// Returns: {msg: string}
  Future<void> verifyEmail({
    required String accessToken,
    required String twoFaToken,
  }) async {
    await _client.postJson(
      '/auth/verify-email',
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-2FA-Token': twoFaToken,
      },
    );
  }

  /// Reset password using 2FA token.
  ///
  /// POST /auth/reset-password
  /// Headers: Authorization: Bearer `accessToken`, X-2FA-Token: `token`
  /// Body: {newPassword: string}
  /// Returns: {msg: string}
  Future<void> resetPassword({
    required String accessToken,
    required String twoFaToken,
    required String newPassword,
  }) async {
    await _client.postJson(
      '/auth/reset-password',
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-2FA-Token': twoFaToken,
      },
      body: {'newPassword': newPassword},
    );
  }
}
