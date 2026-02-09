/// Thin abstraction over secure key-value storage.
///
/// This is only an interface. In the concrete implementation you can
/// use `flutter_secure_storage` or any other secure mechanism.
abstract class SecureStorage {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);
  
  /// Delete all stored keys.
  Future<void> deleteAll();

  /// Read all stored key-value pairs.
  Future<Map<String, String>> readAll();
}

