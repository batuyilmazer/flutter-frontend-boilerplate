import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../core/storage/secure_storage.dart';
import '../core/storage/secure_storage_impl.dart';
import 'theme_data.dart';

/// Notifier that manages theme state across the app.
///
/// Provides methods for changing theme mode (light/dark/system) and
/// automatically persists theme preference to secure storage.
/// Notifies listeners when theme state changes.
class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier({SecureStorage? storage})
    : _storage = storage ?? SecureStorageImpl(),
      _themeMode = ThemeMode.light {
    _loadThemePreference();
  }

  final SecureStorage _storage;
  ThemeMode _themeMode;

  /// Current theme mode (light, dark, or system).
  ThemeMode get themeMode => _themeMode;

  /// Current theme data based on theme mode.
  ///
  /// Returns light or dark theme data. System theme support can be added later.
  AppThemeData get currentThemeData {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppThemeData.light();
      case ThemeMode.dark:
        return AppThemeData.dark();
      case ThemeMode.system:
        // For now, default to light. Can be enhanced to detect system theme.
        return AppThemeData.light();
    }
  }

  /// Set theme mode and persist to storage.
  ///
  /// Updates the theme mode and saves preference to secure storage.
  /// Notifies listeners to trigger UI rebuild.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _saveThemePreference();
    notifyListeners();
  }

  /// Toggle between light and dark theme.
  ///
  /// If current mode is system, switches to light.
  /// If current mode is light, switches to dark.
  /// If current mode is dark, switches to light.
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Load theme preference from storage.
  ///
  /// Called during initialization to restore user's theme preference.
  /// If no preference is found, defaults to light theme.
  Future<void> _loadThemePreference() async {
    try {
      final saved = await _storage.read(SecureStorageKeys.themeMode);
      if (saved != null) {
        final mode = ThemeMode.values.firstWhere(
          (e) => e.name == saved,
          orElse: () => ThemeMode.light,
        );
        if (mode != _themeMode) {
          _themeMode = mode;
          notifyListeners();
        }
      }
    } catch (e) {
      // If loading fails, keep default light theme
      if (kDebugMode) {
        debugPrint('Failed to load theme preference: $e');
      }
    }
  }

  /// Save theme preference to storage.
  ///
  /// Called whenever theme mode changes to persist user preference.
  Future<void> _saveThemePreference() async {
    try {
      await _storage.write(SecureStorageKeys.themeMode, _themeMode.name);
    } catch (e) {
      // If saving fails, log error but don't fail the operation
      if (kDebugMode) {
        debugPrint('Failed to save theme preference: $e');
      }
    }
  }
}
