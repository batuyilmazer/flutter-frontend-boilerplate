import 'dart:convert';

import '../models/user/models.dart';
import 'secure_storage.dart';
import 'secure_storage_impl.dart';
import 'storage_keys.dart';
import 'session_storage.dart';

/// Default implementation of [SessionStorage] backed by [SecureStorage].
class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({SecureStorage? storage})
      : _storage = storage ?? SecureStorageImpl();

  final SecureStorage _storage;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
    required User user,
  }) async {
    await _storage.write(StorageKeys.accessToken, accessToken);
    await _storage.write(StorageKeys.refreshToken, refreshToken);
    await _storage.write(StorageKeys.deviceId, deviceId);
    await saveUser(user);
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage.read(StorageKeys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(StorageKeys.refreshToken);
  }

  @override
  Future<String?> getDeviceId() async {
    return _storage.read(StorageKeys.deviceId);
  }

  @override
  Future<User?> getUser() async {
    final json = await _storage.read(StorageKeys.user);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return User.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    final json = jsonEncode(user.toJson());
    await _storage.write(StorageKeys.user, json);
  }

  @override
  Future<bool> hasSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(StorageKeys.accessToken);
    await _storage.delete(StorageKeys.refreshToken);
    await _storage.delete(StorageKeys.deviceId);
    await _storage.delete(StorageKeys.user);
  }
}

