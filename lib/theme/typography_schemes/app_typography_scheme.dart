import 'package:flutter/material.dart';

/// Typography scheme containing all text styles used in the app.
///
/// Provides consistent typography tokens that can be customized per theme.
class AppTypographyScheme {
  const AppTypographyScheme({
    required this.headline,
    required this.title,
    required this.body,
    required this.bodySmall,
    required this.button,
    required this.caption,
  });

  /// Large, bold text for main titles
  final TextStyle headline;

  /// Medium, semi-bold text for section titles
  final TextStyle title;

  /// Regular text for body content
  final TextStyle body;

  /// Small text for secondary content
  final TextStyle bodySmall;

  /// Text style for buttons
  final TextStyle button;

  /// Small, subtle text for captions
  final TextStyle caption;
}

/// Default typography scheme implementation.
///
/// Uses standard font weights and sizes. Can be extended for custom fonts.
class DefaultTypographyScheme extends AppTypographyScheme {
  const DefaultTypographyScheme()
    : super(
        headline: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: -0.5,
        ),
        title: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 0,
        ),
        body: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0,
        ),
        bodySmall: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: 0,
        ),
        button: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.1,
        ),
        caption: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      );
}
