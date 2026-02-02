import 'package:flutter/material.dart';
import 'theme_data.dart';

/// Builder for converting [AppThemeData] to Flutter's [ThemeData].
///
/// This class provides factory methods to create MaterialApp-compatible
/// ThemeData from our custom AppThemeData configuration.
class ThemeBuilder {
  const ThemeBuilder._();

  /// Build Flutter ThemeData from AppThemeData.
  ///
  /// Converts our custom theme tokens to MaterialApp's ThemeData format.
  /// Includes all necessary theme configurations for Material components.
  static ThemeData buildThemeData(AppThemeData appTheme) {
    return ThemeData(
      colorScheme: appTheme.colors.materialColorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: appTheme.colors.background,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appTheme.colors.primary,
          textStyle: appTheme.typography.button,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.medium),
          ),
          textStyle: appTheme.typography.button,
        ),
      ),
    );
  }
}
