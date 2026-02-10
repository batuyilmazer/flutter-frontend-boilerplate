import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

/// Concrete implementation of [SecureStorage] using `flutter_secure_storage`.
///
/// This implementation stores sensitive auth data securely using platform-specific
/// secure storage mechanisms (Keychain on iOS, KeyStore on Android).
class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          // On mobile platforms, use secure storage plugins.
          (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS
              ? const FlutterSecureStorage(
                  aOptions: AndroidOptions(encryptedSharedPreferences: true),
                  iOptions: IOSOptions(
                    accessibility:
                        KeychainAccessibility.first_unlock_this_device,
                  ),
                )
              // On desktop/web (macOS, Windows, Linux, web), fall back to
              // a simple file-based storage to avoid Keychain entitlements
              // issues during local development.
              : const FlutterSecureStorage());

  final FlutterSecureStorage _storage;

  bool get _useFileStorage =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  File get _fileStorage {
    final home = Platform.environment['HOME'] ?? '.';
    return File('$home/.flutter_frontend_boilerplate_secure.json');
  }

  Future<Map<String, String>> _readFileData() async {
    try {
      if (await _fileStorage.exists()) {
        final contents = await _fileStorage.readAsString();
        if (contents.isEmpty) return <String, String>{};
        final decoded = jsonDecode(contents);
        if (decoded is Map<String, dynamic>) {
          return decoded.map(
            (key, value) => MapEntry(key, value?.toString() ?? ''),
          );
        }
      }
    } catch (_) {}
    return <String, String>{};
  }

  Future<void> _writeFileData(Map<String, String> data) async {
    try {
      await _fileStorage.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  @override
  Future<void> write(String key, String value) async {
    if (_useFileStorage) {
      final data = await _readFileData();
      data[key] = value;
      await _writeFileData(data);
      return;
    }
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    if (_useFileStorage) {
      final data = await _readFileData();
      return data[key];
    }
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    if (_useFileStorage) {
      final data = await _readFileData();
      data.remove(key);
      await _writeFileData(data);
      return;
    }
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    if (_useFileStorage) {
      await _writeFileData(<String, String>{});
      return;
    }
    await _storage.deleteAll();
  }

  @override
  Future<Map<String, String>> readAll() async {
    if (_useFileStorage) {
      return await _readFileData();
    }
    return await _storage.readAll();
  }
}
