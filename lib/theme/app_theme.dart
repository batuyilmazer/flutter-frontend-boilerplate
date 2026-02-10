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
