import 'package:flutter/material.dart';

/// Abstraction for persisting and loading user preferences.
///
/// Keeps the rest of the app independent from concrete key names
/// and underlying storage implementation.
abstract class PreferencesStorage {
  Future<ThemeMode?> getThemeMode();

  Future<void> saveThemeMode(ThemeMode mode);
}
