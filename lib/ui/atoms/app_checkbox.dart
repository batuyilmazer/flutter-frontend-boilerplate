import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// A themed checkbox with an optional label.
///
/// ```dart
/// AppCheckbox(
///   value: isChecked,
///   onChanged: (v) => setState(() => isChecked = v),
///   label: 'Accept terms',
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.size = AppComponentSize.md,
    this.enabled = true,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the value changes.
  final ValueChanged<bool>? onChanged;

  /// Optional label text displayed next to the checkbox.
  final String? label;

  /// Size variant.
  final AppComponentSize size;

  /// Whether the checkbox is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    final scale = switch (size) {
      AppComponentSize.sm => 0.8,
      AppComponentSize.md => 1.0,
      AppComponentSize.lg => 1.2,
    };

    final checkbox = Transform.scale(
      scale: scale,
      child: Checkbox(
        value: value,
        onChanged: enabled ? (v) => onChanged?.call(v ?? false) : null,
      ),
    );

    if (label == null) return checkbox;

    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          SizedBox(width: spacing.s4),
          Text(
            label!,
            style: typography.body.copyWith(
              color: enabled ? colors.textPrimary : colors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
