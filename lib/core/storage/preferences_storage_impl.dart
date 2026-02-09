import 'package:flutter/material.dart';

import 'secure_storage.dart';
import 'secure_storage_impl.dart';
import 'storage_keys.dart';
import 'preferences_storage.dart';

/// Default implementation of [PreferencesStorage] backed by [SecureStorage].
class SecurePreferencesStorage implements PreferencesStorage {
  SecurePreferencesStorage({SecureStorage? storage})
      : _storage = storage ?? SecureStorageImpl();

  final SecureStorage _storage;

  @override
  Future<ThemeMode?> getThemeMode() async {
    final saved = await _storage.read(StorageKeys.themeMode);
    if (saved == null) return null;

    return ThemeMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => ThemeMode.light,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _storage.write(StorageKeys.themeMode, mode.name);
  }
}

