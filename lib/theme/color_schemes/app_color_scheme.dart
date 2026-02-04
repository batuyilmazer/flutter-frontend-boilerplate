import 'package:flutter/material.dart';

/// Interface for app color schemes.
///
/// Implementations should provide all color tokens used throughout the app.
/// This allows for easy theme switching (light/dark/custom).
abstract class AppColorScheme {
  /// Primary brand color
  Color get primary;

  /// Background color for scaffolds
  Color get background;

  /// Primary text color
  Color get textPrimary;

  /// Secondary text color (for hints, labels, etc.)
  Color get textSecondary;

  /// Error color
  Color get error;

  /// Success color
  Color get success;

  /// Surface color (for cards, inputs, etc.)
  Color get surface;

  /// Material Design 3 ColorScheme
  ///
  /// Used by MaterialApp for default Material components
  ColorScheme get materialColorScheme;
}
