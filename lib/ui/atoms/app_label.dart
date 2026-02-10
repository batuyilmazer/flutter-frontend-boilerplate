import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed label for form fields and sections.
///
/// Displays label text with an optional required indicator (*).
///
/// ```dart
/// AppLabel(text: 'Email', isRequired: true)
/// ```
class AppLabel extends StatelessWidget {
  const AppLabel({
    super.key,
    required this.text,
    this.isRequired = false,
    this.style,
    this.color,
  });

  /// The label text.
  final String text;

  /// Whether to show a required indicator (*). Defaults to false.
  final bool isRequired;

  /// Custom text style override.
  final TextStyle? style;

  /// Custom text color override.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typography = context.appTypography;

    final resolvedStyle =
        style ?? typography.bodySmall.copyWith(fontWeight: FontWeight.w600);
    final resolvedColor = color ?? colors.textPrimary;

    if (!isRequired) {
      return Text(text, style: resolvedStyle.copyWith(color: resolvedColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: resolvedStyle.copyWith(color: resolvedColor)),
        Text(' *', style: resolvedStyle.copyWith(color: colors.error)),
      ],
    );
  }
}
