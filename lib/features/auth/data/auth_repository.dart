import '../../../core/errors/app_exception.dart';
import '../../../core/models/user.dart';
import '../../../core/storage/secure_storage_impl.dart';
import 'auth_api.dart';

/// High-level repository for authentication operations.
///
/// Orchestrates [AuthApi] calls and [SecureStorage] operations to provide
/// a clean interface for auth-related features. Handles token persistence,
/// auto-login, and session management.
class AuthRepository {
  AuthRepository({
    AuthApi? authApi,
    SecureStorageImpl? storage,
  })  : _authApi = authApi ?? AuthApi(),
        _storage = storage ?? SecureStorageImpl();

  final AuthApi _authApi;
  final SecureStorageImpl _storage;

  /// Register a new user.
  ///
  /// After successful registration, tokens and user info are automatically
  /// saved to secure storage.
  Future<User> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.register(
        email: email,
        password: password,
      );

      // Save tokens and user info to storage
      await _saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.session.refreshToken,
        deviceId: response.session.deviceId,
        user: response.user,
      );

      return response.user;
    } catch (e) {
      if (e is ApiException) {
        throw AuthException(e.message);
      }
      rethrow;
    }
  }

  /// Login with email and password.
  ///
  /// If a deviceId exists in storage, it will be sent to revoke old tokens
  /// for that device. After successful login, tokens are saved to storage.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      // Get existing deviceId if available (to revoke old tokens)
      final existingDeviceId = await _storage.getDeviceId();

      final response = await _authApi.login(
        email: email,
        password: password,
        deviceId: existingDeviceId,
      );

      // Save tokens and user info to storage
      await _saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.session.refreshToken,
        deviceId: response.session.deviceId,
        user: response.user,
      );

      return response.user;
    } catch (e) {
      if (e is ApiException) {
        throw AuthException(e.message);
      }
      rethrow;
    }
  }

  /// Refresh access token using stored refresh token.
  ///
  /// Automatically updates stored tokens on success.
  /// Throws [AuthException] if refresh fails (user should re-login).
  Future<String> refreshAccessToken() async {
    final refreshToken = await _storage.getRefreshToken();
    final deviceId = await _storage.getDeviceId();

    if (refreshToken == null || deviceId == null) {
      throw AuthException('No refresh token or device ID found');
    }

    try {
      final response = await _authApi.refresh(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );

      // Update stored tokens
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.newRefreshToken);

      return response.accessToken;
    } catch (e) {
      // Refresh failed - clear auth data
      await _storage.clearAuthData();
      if (e is ApiException) {
        throw AuthException('Session expired. Please login again.');
      }
      rethrow;
    }
  }

  /// Logout from current session.
  ///
  /// Revokes refresh token on backend and clears local storage.
  Future<void> logout() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _authApi.logout(refreshToken);
      } catch (e) {
        // Even if backend call fails, clear local storage
        // This ensures user can logout even if network is down
      }
    }
    await _storage.clearAuthData();
  }

  /// Logout from all devices.
  ///
  /// Requires valid access token. Revokes all refresh tokens on backend
  /// and clears local storage.
  Future<void> logoutAll() async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken != null) {
      try {
        await _authApi.logoutAll(accessToken);
      } catch (e) {
        // Even if backend call fails, clear local storage
      }
    }
    await _storage.clearAuthData();
  }

  /// Get current user from storage.
  ///
  /// Returns null if user is not logged in.
  Future<User?> getCurrentUser() async {
    return await _storage.getUser();
  }

  /// Get current access token from storage.
  ///
  /// Returns null if user is not logged in.
  Future<String?> getAccessToken() async {
    return await _storage.getAccessToken();
  }

  /// Check if user is currently logged in.
  ///
  /// Checks for presence of access token and refresh token in storage.
  Future<bool> isLoggedIn() async {
    return await _storage.hasAuthData();
  }

  /// Attempt to restore session from storage.
  ///
  /// If tokens exist, validates them by calling /me endpoint.
  /// Returns user if session is valid, null otherwise.
  Future<User?> restoreSession() async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken == null) return null;

    try {
      // Try to get user info to validate token
      final user = await _authApi.getMe(accessToken);
      // Update user info in storage (in case it changed)
      await _storage.saveUser(user);
      return user;
    } catch (e) {
      // Token might be expired, try refresh
      if (e is ApiException && e.statusCode == 401) {
        try {
          final newAccessToken = await refreshAccessToken();
          final user = await _authApi.getMe(newAccessToken);
          await _storage.saveUser(user);
          return user;
        } catch (_) {
          // Refresh also failed, clear everything
          await _storage.clearAuthData();
          return null;
        }
      }
      // Other errors - clear storage to be safe
      await _storage.clearAuthData();
      return null;
    }
  }

  /// Send 2FA verification email.
  ///
  /// Scope can be "reset-password" or "verify-email".
  Future<void> sendTwoFa({required String scope}) async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken == null) {
      throw AuthException('Not authenticated');
    }

    try {
      await _authApi.sendTwoFa(
        accessToken: accessToken,
        scope: scope,
      );
    } catch (e) {
      if (e is ApiException) {
        throw AuthException(e.message);
      }
      rethrow;
    }
  }

  /// Verify email using 2FA token.
  ///
  /// The 2FA token is typically received via email link.
  Future<void> verifyEmail({required String twoFaToken}) async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken == null) {
      throw AuthException('Not authenticated');
    }

    try {
      await _authApi.verifyEmail(
        accessToken: accessToken,
        twoFaToken: twoFaToken,
      );
      // Refresh user info after verification
      final user = await _authApi.getMe(accessToken);
      await _storage.saveUser(user);
    } catch (e) {
      if (e is ApiException) {
        throw AuthException(e.message);
      }
      rethrow;
    }
  }

  /// Reset password using 2FA token.
  ///
  /// The 2FA token is typically received via email link.
  Future<void> resetPassword({
    required String twoFaToken,
    required String newPassword,
  }) async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken == null) {
      throw AuthException('Not authenticated');
    }

    try {
      await _authApi.resetPassword(
        accessToken: accessToken,
        twoFaToken: twoFaToken,
        newPassword: newPassword,
      );
    } catch (e) {
      if (e is ApiException) {
        throw AuthException(e.message);
      }
      rethrow;
    }
  }

  /// Save authentication data to storage.
  Future<void> _saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
    required User user,
  }) async {
    await _storage.saveAccessToken(accessToken);
    await _storage.saveRefreshToken(refreshToken);
    await _storage.saveDeviceId(deviceId);
    await _storage.saveUser(user);
  }
}

