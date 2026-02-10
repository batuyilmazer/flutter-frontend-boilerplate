import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed multi-line text input.
///
/// Extends the standard text field with defaults appropriate for
/// multi-line content (e.g. descriptions, comments).
///
/// ```dart
/// AppTextarea(
///   controller: _controller,
///   label: 'Description',
///   hint: 'Enter a description...',
///   maxLines: 5,
/// )
/// ```
class AppTextarea extends StatelessWidget {
  const AppTextarea({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.minLines = 3,
    this.maxLines = 5,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.isRequired = false,
    this.showCounter = false,
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Initial value when not using a controller.
  final String? initialValue;

  /// Optional label text displayed above the textarea.
  final String? label;

  /// Placeholder text.
  final String? hint;

  /// Minimum number of visible lines. Defaults to 3.
  final int minLines;

  /// Maximum number of visible lines. Defaults to 5.
  final int maxLines;

  /// Maximum character count.
  final int? maxLength;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Validator for form integration.
  final String? Function(String?)? validator;

  /// Whether the textarea is interactive.
  final bool enabled;

  /// Whether to show a required indicator.
  final bool isRequired;

  /// Whether to show the character counter.
  final bool showCounter;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final field = TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      style: typography.body.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: typography.body.copyWith(color: colors.textSecondary),
        filled: true,
        fillColor: enabled ? colors.surface : colors.disabled,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.input),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.input),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.input),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.all(spacing.s12),
        counterText: showCounter ? null : '',
      ),
    );

    if (label == null) return field;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label!,
              style: typography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: typography.bodySmall.copyWith(color: colors.error),
              ),
          ],
        ),
        SizedBox(height: spacing.s6),
        field,
      ],
    );
  }
}
