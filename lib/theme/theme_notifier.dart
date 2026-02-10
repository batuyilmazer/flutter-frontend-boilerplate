import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/storage/preferences_storage.dart';
import '../core/storage/preferences_storage_impl.dart';
import 'theme_data.dart';

/// Notifier that manages theme state across the app.
///
/// Provides methods for changing theme mode (light/dark/system) and
/// automatically persists theme preference to secure storage.
/// Notifies listeners when theme state changes.
class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier({PreferencesStorage? preferencesStorage})
    : _preferencesStorage = preferencesStorage ?? SecurePreferencesStorage(),
      _themeMode = ThemeMode.dark {
    _initializationFuture = _loadThemePreference();
  }

  final PreferencesStorage _preferencesStorage;
  ThemeMode _themeMode;
  AppThemeData? _cachedThemeData;
  Future<void>? _initializationFuture;

  /// Current theme mode (light, dark, or system).
  ThemeMode get themeMode => _themeMode;

  /// Current theme data based on theme mode.
  ///
  /// Returns light or dark theme data. System theme support can be added later.
  AppThemeData get currentThemeData {
    return _cachedThemeData ??= switch (_themeMode) {
      ThemeMode.light => AppThemeData.light(),
      ThemeMode.dark => AppThemeData.dark(),
      ThemeMode.system =>
        // For now, default to light. Can be enhanced to detect system theme.
        AppThemeData.light(),
    };
  }

  /// Set theme mode and persist to storage.
  ///
  /// Updates the theme mode and saves preference to secure storage.
  /// Notifies listeners to trigger UI rebuild.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    _cachedThemeData = null;
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

  /// Ensures that theme preference loading from storage is complete.
  ///
  /// This is useful in tests or when you need to guarantee that the initial
  /// theme preference has been loaded before accessing themeMode.
  /// In normal app usage, this is not necessary as the UI will update
  /// automatically when the preference is loaded.
  Future<void> ensureInitialized() async {
    await _initializationFuture;
  }

  /// Load theme preference from storage.
  ///
  /// Called during initialization to restore user's theme preference.
  /// If no preference is found, defaults to light theme.
  Future<void> _loadThemePreference() async {
    try {
      final mode = await _preferencesStorage.getThemeMode();
      if (mode != null && mode != _themeMode) {
        _themeMode = mode;
        _cachedThemeData = null;
        notifyListeners();
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
      await _preferencesStorage.saveThemeMode(_themeMode);
    } catch (e) {
      // If saving fails, log error but don't fail the operation
      if (kDebugMode) {
        debugPrint('Failed to save theme preference: $e');
      }
    }
  }
}
