import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed slider for selecting a value from a range.
///
/// Supports both single-value and range selection.
///
/// ```dart
/// AppSlider(
///   value: _volume,
///   onChanged: (v) => setState(() => _volume = v),
///   min: 0,
///   max: 100,
///   label: 'Volume',
/// )
/// ```
class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showLabel = false,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
  });

  /// Current value.
  final double value;

  /// Called when the value changes.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions.
  final int? divisions;

  /// Optional label text displayed above the slider.
  final String? label;

  /// Whether to show the value label tooltip.
  final bool showLabel;

  /// Whether the slider is interactive.
  final bool enabled;

  /// Active track color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    Widget slider = Slider(
      value: value,
      onChanged: enabled ? onChanged : null,
      min: min,
      max: max,
      divisions: divisions,
      label: showLabel
          ? value.toStringAsFixed(divisions != null ? 0 : 1)
          : null,
      activeColor: activeColor ?? colors.primary,
      inactiveColor: inactiveColor ?? colors.border,
    );

    if (label == null) return slider;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: typography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: spacing.s4),
        slider,
      ],
    );
  }
}
