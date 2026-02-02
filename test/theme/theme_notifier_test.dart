import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend_boilerplate/theme/theme_notifier.dart';
import 'package:flutter_frontend_boilerplate/core/storage/secure_storage.dart';

/// Mock implementation of SecureStorage for testing.
class MockSecureStorage implements SecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }
}

void main() {
  group('ThemeNotifier', () {
    test('initial theme mode is light', () {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);
      expect(notifier.themeMode, ThemeMode.light);
    });

    test('currentThemeData returns light theme for light mode', () {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);
      final themeData = notifier.currentThemeData;

      expect(themeData.colors.primary, const Color(0xFF4F46E5));
      expect(themeData.colors.background, const Color(0xFFF9FAFB));
    });

    test('setThemeMode updates theme mode', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      await notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.themeMode, ThemeMode.dark);
    });

    test('setThemeMode persists to storage', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      await notifier.setThemeMode(ThemeMode.dark);
      final saved = await mockStorage.read('theme_mode');
      expect(saved, 'dark');
    });

    test('setThemeMode does not update if mode is same', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      await notifier.setThemeMode(ThemeMode.light);
      final firstSave = await mockStorage.read('theme_mode');

      await notifier.setThemeMode(ThemeMode.light);
      final secondSave = await mockStorage.read('theme_mode');

      expect(firstSave, secondSave);
    });

    test('toggleTheme switches between light and dark', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      expect(notifier.themeMode, ThemeMode.light);

      await notifier.toggleTheme();
      expect(notifier.themeMode, ThemeMode.dark);

      await notifier.toggleTheme();
      expect(notifier.themeMode, ThemeMode.light);
    });

    test('toggleTheme persists to storage', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      await notifier.toggleTheme();
      final saved = await mockStorage.read('theme_mode');
      expect(saved, 'dark');
    });

    test('loads theme preference from storage on initialization', () async {
      final mockStorage = MockSecureStorage();
      await mockStorage.write('theme_mode', 'dark');

      // Create notifier with pre-populated storage
      final notifier = ThemeNotifier(storage: mockStorage);

      // Wait a bit for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notifier.themeMode, ThemeMode.dark);
    });

    test('defaults to light theme if storage is empty', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      // Wait a bit for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notifier.themeMode, ThemeMode.light);
    });

    test('defaults to light theme if invalid value in storage', () async {
      final mockStorage = MockSecureStorage();
      await mockStorage.write('theme_mode', 'invalid_mode');

      final notifier = ThemeNotifier(storage: mockStorage);

      // Wait a bit for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notifier.themeMode, ThemeMode.light);
    });

    test('currentThemeData returns dark theme for dark mode', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      await notifier.setThemeMode(ThemeMode.dark);
      final themeData = notifier.currentThemeData;

      expect(themeData.colors.background, const Color(0xFF111827));
      expect(themeData.colors.textPrimary, const Color(0xFFF9FAFB));
    });

    test('currentThemeData returns light theme for system mode', () async {
      final mockStorage = MockSecureStorage();
      final notifier = ThemeNotifier(storage: mockStorage);

      // Set to system mode
      await notifier.setThemeMode(ThemeMode.system);
      final themeData = notifier.currentThemeData;
      expect(themeData.colors.background, const Color(0xFFF9FAFB));
    });
  });
}
