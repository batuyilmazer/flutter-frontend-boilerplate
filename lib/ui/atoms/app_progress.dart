import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Progress indicator variant.
enum AppProgressVariant { linear, circular }

/// A themed progress indicator (linear or circular).
///
/// Pass a [value] between 0.0 and 1.0 for a determinate indicator,
/// or leave it null for an indeterminate animation.
///
/// ```dart
/// AppProgress(value: 0.7)                                    // linear determinate
/// AppProgress(variant: AppProgressVariant.circular)           // circular indeterminate
/// ```
class AppProgress extends StatelessWidget {
  const AppProgress({
    super.key,
    this.value,
    this.variant = AppProgressVariant.linear,
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.height,
  });

  /// Progress value between 0.0 and 1.0. Null = indeterminate.
  final double? value;

  /// Linear or circular. Defaults to linear.
  final AppProgressVariant variant;

  /// Indicator color. Defaults to theme primary.
  final Color? color;

  /// Track color. Defaults to theme border.
  final Color? trackColor;

  /// Stroke width for circular variant, or bar height for linear.
  final double? strokeWidth;

  /// Height constraint (only used for linear variant).
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resolvedColor = color ?? colors.primary;
    final resolvedTrack = trackColor ?? colors.border;

    if (variant == AppProgressVariant.circular) {
      return SizedBox(
        width: strokeWidth != null ? (strokeWidth! * 8) : null,
        height: strokeWidth != null ? (strokeWidth! * 8) : null,
        child: CircularProgressIndicator(
          value: value,
          color: resolvedColor,
          backgroundColor: resolvedTrack,
          strokeWidth: strokeWidth ?? 4,
        ),
      );
    }

    return SizedBox(
      height: height ?? 4,
      child: LinearProgressIndicator(
        value: value,
        color: resolvedColor,
        backgroundColor: resolvedTrack,
        borderRadius: BorderRadius.circular(context.appRadius.full),
      ),
    );
  }
}
