import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Reusable text component that uses app typography tokens.
///
/// Instead of using `Text` directly, use `AppText` to ensure consistent
/// typography across the app. Customize styles via `AppTypography`.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  /// Headline style - large, bold text for titles
  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = AppTypography.headline;

  /// Title style - medium, semi-bold text
  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = AppTypography.title;

  /// Body style - regular text
  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = AppTypography.body;

  /// Small body style
  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = AppTypography.bodySmall;

  /// Caption style - small, subtle text
  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = AppTypography.caption;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? AppTypography.body).copyWith(color: color),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

