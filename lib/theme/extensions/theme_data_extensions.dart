import 'package:flutter/material.dart';
import '../theme_data.dart';
import '../theme_builder.dart';

/// Extension methods for [AppThemeData] to provide convenient conversions.
extension AppThemeDataExtensions on AppThemeData {
  /// Convert [AppThemeData] to Flutter's [ThemeData].
  ///
  /// This is a convenience method that delegates to [ThemeBuilder.buildThemeData].
  /// Use this for a more fluent API when working with AppThemeData.
  ///
  /// Example:
  /// ```dart
  /// final themeData = AppThemeData.light().toThemeData();
  /// ```
  ThemeData toThemeData() {
    return ThemeBuilder.buildThemeData(this);
  }
}
