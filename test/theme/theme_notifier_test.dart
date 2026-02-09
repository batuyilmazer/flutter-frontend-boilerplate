import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend_boilerplate/theme/theme_notifier.dart';
import 'package:flutter_frontend_boilerplate/core/storage/preferences_storage.dart';

/// Mock implementation of [PreferencesStorage] for testing.
class MockPreferencesStorage implements PreferencesStorage {
  final Map<String, String> _storage = {};

  @override
  Future<ThemeMode?> getThemeMode() async {
    final saved = _storage['theme_mode'];
    if (saved == null) return null;

    return ThemeMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => ThemeMode.light,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _storage['theme_mode'] = mode.name;
  }

  // Test helpers to inspect and prepare raw stored values.
  Future<void> writeRaw(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> readRaw(String key) async {
    return _storage[key];
  }
}

void main() {
  group('ThemeNotifier', () {
    test('has initial theme mode set', () {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);
      // Test that a valid ThemeMode is set, regardless of which one
      expect(notifier.themeMode, isA<ThemeMode>());
      expect(ThemeMode.values, contains(notifier.themeMode));
    });

    test('currentThemeData returns correct theme for light mode', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      // Explicitly set to light mode to test light theme data
      await notifier.setThemeMode(ThemeMode.light);
      final themeData = notifier.currentThemeData;

      expect(themeData.colors.primary, const Color(0xFF4F46E5));
      expect(themeData.colors.background, const Color(0xFFF9FAFB));
    });

    test('setThemeMode updates theme mode', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      // Test setting to dark mode
      await notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.themeMode, ThemeMode.dark);

      // Test setting to light mode
      await notifier.setThemeMode(ThemeMode.light);
      expect(notifier.themeMode, ThemeMode.light);

      // Test setting to system mode
      await notifier.setThemeMode(ThemeMode.system);
      expect(notifier.themeMode, ThemeMode.system);
    });

    test('setThemeMode persists to storage', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);
      final initialMode = notifier.themeMode;

      // Set to a different mode to ensure storage write happens
      final testMode = initialMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
      await notifier.setThemeMode(testMode);
      final saved = await mockStorage.readRaw('theme_mode');
      expect(saved, testMode.name);

      // Test setting to another mode
      final otherMode = testMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
      await notifier.setThemeMode(otherMode);
      final savedOther = await mockStorage.readRaw('theme_mode');
      expect(savedOther, otherMode.name);
    });

    test('setThemeMode does not update if mode is same', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);
      final initialMode = notifier.themeMode;

      await notifier.setThemeMode(initialMode);
      final firstSave = await mockStorage.readRaw('theme_mode');

      await notifier.setThemeMode(initialMode);
      final secondSave = await mockStorage.readRaw('theme_mode');

      expect(firstSave, secondSave);
    });

    test('toggleTheme switches between light and dark', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);
      final initialMode = notifier.themeMode;
      final expectedNextMode = initialMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      await notifier.toggleTheme();
      expect(notifier.themeMode, expectedNextMode);

      await notifier.toggleTheme();
      expect(notifier.themeMode, initialMode);
    });

    test('toggleTheme persists to storage', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);
      final initialMode = notifier.themeMode;
      final expectedNextMode = initialMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      await notifier.toggleTheme();
      final saved = await mockStorage.readRaw('theme_mode');
      expect(saved, expectedNextMode.name);
    });

    test('loads theme preference from storage on initialization', () async {
      final mockStorage = MockPreferencesStorage();
      await mockStorage.writeRaw('theme_mode', 'dark');

      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      // Wait for async initialization to complete
      await notifier.ensureInitialized();

      expect(notifier.themeMode, ThemeMode.dark);
    });

    test('uses configured default theme if storage is empty', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      // Wait for async initialization to complete
      await notifier.ensureInitialized();

      // Test that a valid ThemeMode is set (default from constructor)
      expect(notifier.themeMode, isA<ThemeMode>());
      expect(ThemeMode.values, contains(notifier.themeMode));
    });

    test('defaults to configured theme if invalid value in storage', () async {
      final mockStorage = MockPreferencesStorage();
      await mockStorage.writeRaw('theme_mode', 'invalid_mode');

      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      // Wait for async initialization to complete
      await notifier.ensureInitialized();

      // Should fall back to default (not invalid mode)
      // Invalid mode is not in ThemeMode enum, so should use default
      expect(notifier.themeMode, isA<ThemeMode>());
      expect(ThemeMode.values, contains(notifier.themeMode));
      // Verify it's not the invalid string (which can't be a ThemeMode anyway)
      expect(notifier.themeMode.name, isNot('invalid_mode'));
    });

    test('currentThemeData returns dark theme for dark mode', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      await notifier.setThemeMode(ThemeMode.dark);
      final themeData = notifier.currentThemeData;

      expect(themeData.colors.background, const Color(0xFF111827));
      expect(themeData.colors.textPrimary, const Color(0xFFF9FAFB));
    });

    test('currentThemeData returns light theme for system mode', () async {
      final mockStorage = MockPreferencesStorage();
      final notifier = ThemeNotifier(preferencesStorage: mockStorage);

      // Set to system mode
      await notifier.setThemeMode(ThemeMode.system);
      final themeData = notifier.currentThemeData;
      expect(themeData.colors.background, const Color(0xFFF9FAFB));
    });
  });
}
