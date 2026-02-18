import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

/// Light theme color scheme implementation.
///
/// Uses bright colors suitable for light backgrounds.
class LightColorScheme implements AppColorScheme {
  const LightColorScheme();

  @override
  Color get primary => const Color(0xFF18181B);

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get background => const Color(0xFFFFFFFF);

  @override
  Color get textPrimary => const Color(0xFF09090B);

  @override
  Color get textSecondary => const Color(0xFF71717A);

  @override
  Color get textDisabled => const Color(0xFFA1A1AA);

  @override
  Color get error => const Color(0xFFEF4444);

  @override
  Color get success => const Color(0xFF22C55E);

  @override
  Color get warning => const Color(0xFFF59E0B);

  @override
  Color get info => const Color(0xFF3B82F6);

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get onSurface => textPrimary;

  @override
  Color get surfaceVariant => const Color(0xFFF4F4F5);

  @override
  Color get border => const Color(0xFFE4E4E7);

  @override
  Color get divider => border;

  @override
  Color get disabled => const Color(0xFFF4F4F5);

  @override
  Color get overlay => const Color(0x80000000);

  @override
  Color get iconSubtle => textSecondary;

  @override
  Color get iconStrong => textPrimary;

  @override
  ColorScheme get materialColorScheme =>
      ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light);
}
