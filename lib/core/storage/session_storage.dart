import '../models/user/models.dart';

/// Abstraction for persisting and loading authentication/session data.
///
/// This sits on top of [SecureStorage] and exposes domain-level concepts
/// such as access token, refresh token, device id and current user.
abstract class SessionStorage {
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
    required User user,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getDeviceId();

  Future<User?> getUser();

  Future<void> saveUser(User user);

  /// Returns true if there is enough data to consider a session present.
  Future<bool> hasSession();

  /// Clears all session-related data (tokens, device id, user).
  Future<void> clearSession();
}
