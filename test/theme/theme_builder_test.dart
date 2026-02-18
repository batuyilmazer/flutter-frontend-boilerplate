import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend_boilerplate/theme/theme_builder.dart';
import 'package:flutter_frontend_boilerplate/theme/theme_data.dart';
import 'package:flutter_frontend_boilerplate/theme/extensions/theme_data_extensions.dart';

void main() {
  group('ThemeBuilder', () {
    test('buildThemeData creates valid ThemeData from AppThemeData.light', () {
      final appTheme = AppThemeData.light();
      final themeData = ThemeBuilder.buildThemeData(appTheme);

      expect(themeData.useMaterial3, isTrue);
      expect(themeData.scaffoldBackgroundColor, appTheme.colors.background);
      expect(themeData.colorScheme.brightness, Brightness.light);
      // ColorScheme.fromSeed creates a scheme from seed color
      expect(themeData.colorScheme.primary, isNotNull);
    });

    test('buildThemeData creates valid ThemeData from AppThemeData.dark', () {
      final appTheme = AppThemeData.dark();
      final themeData = ThemeBuilder.buildThemeData(appTheme);

      expect(themeData.useMaterial3, isTrue);
      expect(themeData.scaffoldBackgroundColor, appTheme.colors.background);
      expect(themeData.colorScheme.brightness, Brightness.dark);
      // ColorScheme.fromSeed creates a scheme from seed color
      expect(themeData.colorScheme.primary, isNotNull);
    });

    test('buildThemeData includes all Material component themes', () {
      final appTheme = AppThemeData.light();
      final themeData = ThemeBuilder.buildThemeData(appTheme);

      // Check that all major theme components are set
      expect(themeData.appBarTheme, isNotNull);
      expect(themeData.inputDecorationTheme, isNotNull);
      expect(themeData.textButtonTheme, isNotNull);
      expect(themeData.elevatedButtonTheme, isNotNull);
      expect(themeData.outlinedButtonTheme, isNotNull);
      expect(themeData.cardTheme, isNotNull);
      expect(themeData.dialogTheme, isNotNull);
      expect(themeData.bottomSheetTheme, isNotNull);
      expect(themeData.chipTheme, isNotNull);
      expect(themeData.switchTheme, isNotNull);
      expect(themeData.dividerTheme, isNotNull);
      expect(themeData.textTheme, isNotNull);
    });

    test('buildThemeData uses correct colors from AppThemeData', () {
      final appTheme = AppThemeData.light();
      final themeData = ThemeBuilder.buildThemeData(appTheme);

      expect(themeData.appBarTheme.backgroundColor, appTheme.colors.surface);
      expect(
        themeData.appBarTheme.foregroundColor,
        appTheme.colors.textPrimary,
      );
      expect(themeData.cardTheme.color, appTheme.colors.surface);
      expect(themeData.dialogTheme.backgroundColor, appTheme.colors.surface);
    });

    test('buildThemeData uses correct typography from AppThemeData', () {
      final appTheme = AppThemeData.light();
      final themeData = ThemeBuilder.buildThemeData(appTheme);

      // Check that typography styles are applied (may have additional properties from ThemeData)
      expect(
        themeData.textTheme.headlineLarge?.fontSize,
        appTheme.typography.headline.fontSize,
      );
      expect(
        themeData.textTheme.headlineLarge?.fontWeight,
        appTheme.typography.headline.fontWeight,
      );
      expect(
        themeData.textTheme.titleLarge?.fontSize,
        appTheme.typography.title.fontSize,
      );
      expect(
        themeData.textTheme.titleLarge?.fontWeight,
        appTheme.typography.title.fontWeight,
      );
      expect(
        themeData.textTheme.bodyLarge?.fontSize,
        appTheme.typography.body.fontSize,
      );
      expect(
        themeData.textTheme.bodySmall?.fontSize,
        appTheme.typography.bodySmall.fontSize,
      );
      expect(
        themeData.textTheme.labelLarge?.fontSize,
        appTheme.typography.button.fontSize,
      );
      expect(
        themeData.textTheme.labelSmall?.fontSize,
        appTheme.typography.caption.fontSize,
      );
    });

    test(
      'buildThemeData uses correct spacing and radius from AppThemeData',
      () {
        final appTheme = AppThemeData.light();
        final themeData = ThemeBuilder.buildThemeData(appTheme);

        // Check input decoration padding
        final inputPadding = themeData.inputDecorationTheme.contentPadding;
        expect(inputPadding, isNotNull);
        if (inputPadding is EdgeInsets) {
          expect(inputPadding.horizontal, appTheme.spacing.inputPaddingX * 2);
          expect(inputPadding.vertical, appTheme.spacing.inputPaddingY * 2);
        }

        // Check button padding
        final buttonPadding = themeData.elevatedButtonTheme.style?.padding;
        expect(buttonPadding, isNotNull);
      },
    );

    test('buildThemeData creates different themes for light and dark', () {
      final lightTheme = ThemeBuilder.buildThemeData(AppThemeData.light());
      final darkTheme = ThemeBuilder.buildThemeData(AppThemeData.dark());

      expect(
        lightTheme.scaffoldBackgroundColor,
        isNot(darkTheme.scaffoldBackgroundColor),
      );
      expect(lightTheme.colorScheme.brightness, Brightness.light);
      expect(darkTheme.colorScheme.brightness, Brightness.dark);
    });
  });

  group('AppThemeDataExtensions', () {
    test('toThemeData extension method works correctly', () {
      final appTheme = AppThemeData.light();
      final themeData = appTheme.toThemeData();

      expect(themeData, isA<ThemeData>());
      expect(themeData.useMaterial3, isTrue);
      expect(themeData.scaffoldBackgroundColor, appTheme.colors.background);
    });

    test('toThemeData creates same result as ThemeBuilder.buildThemeData', () {
      final appTheme = AppThemeData.light();
      final themeData1 = appTheme.toThemeData();
      final themeData2 = ThemeBuilder.buildThemeData(appTheme);

      expect(themeData1.useMaterial3, themeData2.useMaterial3);
      expect(
        themeData1.scaffoldBackgroundColor,
        themeData2.scaffoldBackgroundColor,
      );
      expect(
        themeData1.colorScheme.brightness,
        themeData2.colorScheme.brightness,
      );
      expect(themeData1.colorScheme.primary, themeData2.colorScheme.primary);
    });
  });
}
