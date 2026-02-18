import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// Reusable text field component that uses app theme tokens.
///
/// Provides consistent input styling across the app. Supports common
/// input types and validation states.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
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
    this.size = AppComponentSize.md,
  });

  final TextEditingController? controller;
  final String? label;
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
  /// Semantic size for the input (sm, md, lg).
  final AppComponentSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typography = context.appTypography;
    final radius = context.appRadius;
    final spacing = context.appSpacing;
    final sizes = context.appSizes;

    final minHeight = sizes.inputHeight(size);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        autofocus: autofocus,
        style: typography.body.copyWith(color: colors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          errorText: errorText,
          labelStyle:
              typography.bodySmall.copyWith(color: colors.textSecondary),
          hintStyle:
              typography.bodySmall.copyWith(color: colors.textSecondary),
          errorStyle: typography.caption.copyWith(color: colors.error),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.input),
            borderSide: BorderSide(color: colors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.input),
            borderSide: BorderSide(color: colors.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.input),
            borderSide: BorderSide(color: colors.disabled),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.inputPaddingX,
            vertical: spacing.inputPaddingY,
          ),
        ),
      ),
    );
  }
}
