/// Thin abstraction over secure storage for auth-related values.
///
/// This is only an interface for now. In the concrete implementation you can
/// use `flutter_secure_storage` or any other secure mechanism.
abstract class SecureStorage {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);
}

/// Keys used to persist auth/session data.
class SecureStorageKeys {
  const SecureStorageKeys._();

  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const deviceId = 'device_id';
  static const user = 'user_json';
}


