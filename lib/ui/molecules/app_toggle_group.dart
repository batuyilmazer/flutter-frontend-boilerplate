import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// A single item in an [AppToggleGroup].
class AppToggleItem<T> {
  const AppToggleItem({required this.value, required this.label, this.icon});

  /// The backing value.
  final T value;

  /// Display label.
  final String label;

  /// Optional icon.
  final Widget? icon;
}

/// A themed segmented toggle button group.
///
/// ```dart
/// AppToggleGroup<String>(
///   items: [
///     AppToggleItem(value: 'list', label: 'List', icon: Icon(Icons.list)),
///     AppToggleItem(value: 'grid', label: 'Grid', icon: Icon(Icons.grid_view)),
///   ],
///   value: _view,
///   onChanged: (v) => setState(() => _view = v),
/// )
/// ```
class AppToggleGroup<T> extends StatelessWidget {
  const AppToggleGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.size = AppComponentSize.md,
    this.enabled = true,
  });

  /// The toggle items.
  final List<AppToggleItem<T>> items;

  /// Currently selected value.
  final T value;

  /// Called when the selection changes.
  final ValueChanged<T> onChanged;

  /// Size variant.
  final AppComponentSize size;

  /// Whether the group is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final shadows = context.appShadows;
    final typography = context.appTypography;

    final (hPad, vPad, textStyle) = switch (size) {
      AppComponentSize.sm => (spacing.s8, spacing.s4, typography.caption),
      AppComponentSize.md => (spacing.s12, spacing.s8, typography.bodySmall),
      AppComponentSize.lg => (spacing.s16, spacing.s12, typography.body),
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.toggle),
        border: Border.all(color: colors.border),
        color: colors.surfaceVariant,
      ),
      padding: EdgeInsets.all(spacing.s2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isSelected = item.value == value;

          return GestureDetector(
            onTap: enabled && !isSelected ? () => onChanged(item.value) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              decoration: BoxDecoration(
                color: isSelected ? colors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.toggle),
                boxShadow: isSelected
                    ? shadows.list(shadows.toggleSelected)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        size: textStyle.fontSize! + 4,
                        color: isSelected
                            ? colors.textPrimary
                            : colors.textSecondary,
                      ),
                      child: item.icon!,
                    ),
                    SizedBox(width: spacing.s4),
                  ],
                  Text(
                    item.label,
                    style: textStyle.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? colors.textPrimary
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
