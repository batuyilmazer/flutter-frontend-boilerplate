import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed toggle switch with an optional label.
///
/// ```dart
/// AppSwitch(
///   value: isDarkMode,
///   onChanged: (v) => setState(() => isDarkMode = v),
///   label: 'Dark mode',
/// )
/// ```
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called when the value changes.
  final ValueChanged<bool>? onChanged;

  /// Optional label text displayed next to the switch.
  final String? label;

  /// Whether the switch is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    final toggle = Switch(value: value, onChanged: enabled ? onChanged : null);

    if (label == null) return toggle;

    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          toggle,
          SizedBox(width: spacing.s8),
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
