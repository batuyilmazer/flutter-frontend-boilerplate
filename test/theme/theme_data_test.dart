import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend_boilerplate/theme/theme_data.dart';
import 'package:flutter_frontend_boilerplate/theme/color_schemes/light_color_scheme.dart';
import 'package:flutter_frontend_boilerplate/theme/color_schemes/dark_color_scheme.dart';
import 'package:flutter_frontend_boilerplate/theme/spacing_schemes/app_spacing_scheme.dart';

void main() {
  group('AppThemeData', () {
    test('light() factory creates light theme with correct schemes', () {
      final theme = AppThemeData.light();

      expect(theme.colors, isA<LightColorScheme>());
      expect(theme.colors.primary, const Color(0xFF18181B));
      expect(theme.colors.background, const Color(0xFFFFFFFF));
      expect(theme.typography.headline.fontSize, 24);
      expect(theme.spacing.s4, 4);
      expect(theme.radius.small, 6);
    });

    test('dark() factory creates dark theme with correct schemes', () {
      final theme = AppThemeData.dark();

      expect(theme.colors, isA<DarkColorScheme>());
      expect(theme.colors.background, const Color(0xFF09090B));
      expect(theme.colors.textPrimary, const Color(0xFFFAFAFA));
      expect(theme.typography.headline.fontSize, 24);
      expect(theme.spacing.s4, 4);
      expect(theme.radius.small, 6);
    });

    test('copyWith creates new instance with updated values', () {
      final lightTheme = AppThemeData.light();
      final customSpacing = DefaultSpacingScheme();

      final customTheme = lightTheme.copyWith(spacing: customSpacing);

      expect(customTheme.colors, lightTheme.colors);
      expect(customTheme.typography, lightTheme.typography);
      expect(customTheme.spacing, customSpacing);
      expect(customTheme.radius, lightTheme.radius);
    });

    test('equality works correctly for identical themes', () {
      final theme1 = AppThemeData.light();
      final theme2 = AppThemeData.light();

      expect(theme1, equals(theme2));
    });

    test('light and dark themes are not equal', () {
      final lightTheme = AppThemeData.light();
      final darkTheme = AppThemeData.dark();

      expect(lightTheme, isNot(equals(darkTheme)));
    });
  });
}
