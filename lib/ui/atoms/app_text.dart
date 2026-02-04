import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

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
  }) : _variant = _AppTextVariant.custom;

  final String text;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final _AppTextVariant _variant;

  /// Headline style - large, bold text for titles
  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.headline;

  /// Title style - medium, semi-bold text
  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.title;

  /// Body style - regular text
  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.body;

  /// Small body style
  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.bodySmall;

  /// Caption style - small, subtle text
  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.caption;

  @override
  Widget build(BuildContext context) {
    final typography = context.appTypography;

    TextStyle baseStyle;
    switch (_variant) {
      case _AppTextVariant.headline:
        baseStyle = typography.headline;
        break;
      case _AppTextVariant.title:
        baseStyle = typography.title;
        break;
      case _AppTextVariant.body:
        baseStyle = typography.body;
        break;
      case _AppTextVariant.bodySmall:
        baseStyle = typography.bodySmall;
        break;
      case _AppTextVariant.caption:
        baseStyle = typography.caption;
        break;
      case _AppTextVariant.custom:
        baseStyle = style ?? typography.body;
        break;
    }

    return Text(
      text,
      style: baseStyle.copyWith(color: color),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

/// Internal variants for [AppText] to map to typography tokens.
enum _AppTextVariant { custom, headline, title, body, bodySmall, caption }
