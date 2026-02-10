import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A single item in an [AppRadioGroup].
class AppRadioItem<T> {
  const AppRadioItem({required this.value, required this.label});

  /// The value this radio represents.
  final T value;

  /// The label displayed next to the radio.
  final String label;
}

/// A themed group of radio buttons.
///
/// ```dart
/// AppRadioGroup<String>(
///   items: [
///     AppRadioItem(value: 'a', label: 'Option A'),
///     AppRadioItem(value: 'b', label: 'Option B'),
///   ],
///   value: selected,
///   onChanged: (v) => setState(() => selected = v),
/// )
/// ```
class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.direction = Axis.vertical,
    this.enabled = true,
  });

  /// The list of radio items.
  final List<AppRadioItem<T>> items;

  /// The currently selected value.
  final T? value;

  /// Called when the selection changes.
  final ValueChanged<T>? onChanged;

  /// Layout direction. Defaults to vertical.
  final Axis direction;

  /// Whether the radio group is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    final children = items.map((item) {
      return GestureDetector(
        onTap: enabled ? () => onChanged?.call(item.value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup<T>(
              groupValue: value,
              onChanged: enabled ? (v) => onChanged?.call(v as T) : (_) {},
              child: Radio<T>(value: item.value),
            ),
            SizedBox(width: spacing.s4),
            Text(
              item.label,
              style: typography.body.copyWith(
                color: enabled ? colors.textPrimary : colors.textDisabled,
              ),
            ),
          ],
        ),
      );
    }).toList();

    if (direction == Axis.horizontal) {
      return Wrap(
        spacing: spacing.s16,
        runSpacing: spacing.s8,
        children: children,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
