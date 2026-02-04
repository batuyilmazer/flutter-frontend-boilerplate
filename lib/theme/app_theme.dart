import 'package:flutter/material.dart';
import 'theme_data.dart';
import 'extensions/theme_data_extensions.dart';

/// Central place to configure the app's themes and design tokens.
///
/// Other UI components should read colors, text styles, and shapes from here
/// instead of using `Colors.*` or magic numbers directly.
class AppTheme {
  const AppTheme._();

  /// Light theme configuration for the app.
  static ThemeData get light {
    // Legacy entry point kept for backward compatibility.
    // New code should prefer AppThemeData.light().toThemeData().
    return AppThemeData.light().toThemeData();
  }
}

/// Basic color tokens for the boilerplate.
///
/// Customize these to change the visual identity of the app.
@Deprecated('Use AppThemeData + context extensions (context.appColors) instead')
class AppColors {
  AppColors._();
  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF9FAFB);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const surface = Color(0xFFFFFFFF);
}

/// Basic radius tokens for consistent corner rounding.
@Deprecated('Use AppThemeData + context extensions (context.appRadius) instead')
class AppRadius {
  AppRadius._();
  static const double small = 4;
  static const double medium = 8;
  static const double large = 16;
}

/// Basic spacing tokens for consistent padding/margins.
@Deprecated(
  'Use AppThemeData + context extensions (context.appSpacing) instead',
)
class AppSpacing {
  AppSpacing._();
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
}

/// Basic typography tokens for the boilerplate.
@Deprecated(
  'Use AppThemeData + context extensions (context.appTypography) instead',
)
class AppTypography {
  AppTypography._();
  static const TextStyle headline = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: -0.5,
  );
  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    letterSpacing: 0,
  );
  static const TextStyle body = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    letterSpacing: 0,
  );
  static const TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    letterSpacing: 0,
  );
  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    letterSpacing: 0.1,
  );
  static const TextStyle caption = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    letterSpacing: 0.2,
  );
}
