import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

/// Light theme color scheme implementation.
///
/// Uses bright colors suitable for light backgrounds.
class LightColorScheme implements AppColorScheme {
  const LightColorScheme();

  @override
  Color get primary => const Color(0xFF4F46E5);

  @override
  Color get background => const Color(0xFFF9FAFB);

  @override
  Color get textPrimary => const Color(0xFF111827);

  @override
  Color get textSecondary => const Color(0xFF6B7280);

  @override
  Color get error => const Color(0xFFEF4444);

  @override
  Color get success => const Color(0xFF10B981);

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  ColorScheme get materialColorScheme =>
      ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light);
}
