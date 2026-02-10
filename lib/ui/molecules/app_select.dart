import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// A single item in an [AppSelect] dropdown.
class AppSelectItem<T> {
  const AppSelectItem({required this.value, required this.label, this.icon});

  /// The backing value.
  final T value;

  /// Display text.
  final String label;

  /// Optional leading icon.
  final Widget? icon;
}

/// A themed dropdown / select field.
///
/// Wraps [DropdownButtonFormField] with consistent theme styling.
///
/// ```dart
/// AppSelect<String>(
///   items: [
///     AppSelectItem(value: 'a', label: 'Option A'),
///     AppSelectItem(value: 'b', label: 'Option B'),
///   ],
///   value: selected,
///   onChanged: (v) => setState(() => selected = v),
///   hint: 'Select an option',
/// )
/// ```
class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.label,
    this.size = AppComponentSize.md,
    this.isRequired = false,
    this.enabled = true,
    this.validator,
  });

  /// The list of selectable items.
  final List<AppSelectItem<T>> items;

  /// The currently selected value.
  final T? value;

  /// Called when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Placeholder text when no item is selected.
  final String? hint;

  /// Optional label displayed above the dropdown.
  final String? label;

  /// Size variant. Defaults to [AppComponentSize.md].
  final AppComponentSize size;

  /// Whether to show a required indicator on the label.
  final bool isRequired;

  /// Whether the dropdown is interactive.
  final bool enabled;

  /// Optional validator for [FormField] integration.
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;
    final sizes = context.appSizes;

    final inputHeight = sizes.inputHeight(size);

    final textStyle = switch (size) {
      AppComponentSize.sm => typography.bodySmall,
      AppComponentSize.md => typography.body,
      AppComponentSize.lg => typography.body,
    };

    final dropdown = DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      hint: hint != null
          ? Text(hint!, style: textStyle.copyWith(color: colors.textSecondary))
          : null,
      icon: Icon(Icons.keyboard_arrow_down, color: colors.textSecondary),
      dropdownColor: colors.surface,
      style: textStyle.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: (inputHeight - textStyle.fontSize! - 8) / 2,
        ),
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
        filled: true,
        fillColor: colors.surface,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                item.icon!,
                SizedBox(width: spacing.s8),
              ],
              Text(item.label),
            ],
          ),
        );
      }).toList(),
    );

    if (label == null) return dropdown;

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
        dropdown,
      ],
    );
  }
}
