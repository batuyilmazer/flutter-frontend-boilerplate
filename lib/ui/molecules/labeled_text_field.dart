import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../atoms/app_text.dart';
import '../atoms/app_text_field.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A text field with a label above it.
///
/// Useful for forms where you want explicit labels separate from
/// the input's placeholder/hint.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofocus = false,
    this.errorText,
    this.isRequired = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final String? errorText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.bodySmall(
              label,
              color: colors.textPrimary,
            ),
            if (isRequired)
              AppText.bodySmall(
                ' *',
                color: colors.error,
              ),
          ],
        ),
        SizedBox(height: spacing.s8),
        AppTextField(
          controller: controller,
          hint: hint,
          obscureText: obscureText,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          errorText: errorText,
        ),
      ],
    );
  }
}

