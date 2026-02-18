import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

/// Dark theme color scheme implementation.
///
/// Uses darker colors suitable for dark backgrounds.
class DarkColorScheme implements AppColorScheme {
  const DarkColorScheme();

  @override
  Color get primary => const Color(0xFFFAFAFA);

  @override
  Color get onPrimary => const Color(0xFF09090B);

  @override
  Color get background => const Color(0xFF09090B);

  @override
  Color get textPrimary => const Color(0xFFFAFAFA);

  @override
  Color get textSecondary => const Color(0xFFA1A1AA);

  @override
  Color get textDisabled => const Color(0xFF71717A);

  @override
  Color get error => const Color(0xFFF87171);

  @override
  Color get success => const Color(0xFF4ADE80);

  @override
  Color get warning => const Color(0xFFFBBF24);

  @override
  Color get info => const Color(0xFF60A5FA);

  @override
  Color get surface => const Color(0xFF18181B);

  @override
  Color get onSurface => textPrimary;

  @override
  Color get surfaceVariant => const Color(0xFF27272A);

  @override
  Color get border => const Color(0xFF27272A);

  @override
  Color get divider => border;

  @override
  Color get disabled => const Color(0xFF27272A);

  @override
  Color get overlay => const Color(0xB3000000);

  @override
  Color get iconSubtle => textSecondary;

  @override
  Color get iconStrong => textPrimary;

  @override
  ColorScheme get materialColorScheme =>
      ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark);
}
