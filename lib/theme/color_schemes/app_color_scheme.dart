import 'package:flutter/material.dart';

/// Interface for app color schemes.
///
/// Implementations should provide all color tokens used throughout the app.
/// This allows for easy theme switching (light/dark/custom).
abstract class AppColorScheme {
  /// Primary brand color
  Color get primary;

  /// Foreground color shown on top of [primary] (text/icons).
  Color get onPrimary;

  /// Background color for scaffolds
  Color get background;

  /// Primary text color
  Color get textPrimary;

  /// Secondary text color (for hints, labels, etc.)
  Color get textSecondary;

  /// Disabled text color
  Color get textDisabled;

  /// Error color
  Color get error;

  /// Success color
  Color get success;

  /// Warning color
  Color get warning;

  /// Informational color
  Color get info;

  /// Surface color (for cards, inputs, etc.)
  Color get surface;

  /// Foreground color shown on top of [surface] (text/icons).
  Color get onSurface;

  /// Alternate surface color (for skeleton backgrounds, zebra rows, etc.)
  Color get surfaceVariant;

  /// Subtle border color
  Color get border;

  /// Divider color (usually same as [border]).
  Color get divider;

  /// Disabled state fill color
  Color get disabled;

  /// Semi-transparent overlay / scrim color
  Color get overlay;

  /// Subtle icon color for secondary/disabled iconography.
  Color get iconSubtle;

  /// Strong icon color for primary iconography.
  Color get iconStrong;

  /// Material Design 3 ColorScheme
  ///
  /// Used by MaterialApp for default Material components
  ColorScheme get materialColorScheme;
}
