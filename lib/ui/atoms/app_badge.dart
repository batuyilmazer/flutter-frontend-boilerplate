import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// Badge color variant.
enum AppBadgeVariant { primary, success, error, warning, info }

/// A small label / count indicator badge.
///
/// Useful for status indicators, notification counts, and category tags.
///
/// ```dart
/// AppBadge(label: 'New', variant: AppBadgeVariant.success)
/// ```
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.primary,
    this.size = AppComponentSize.sm,
  });

  /// The text content of the badge.
  final String label;

  /// Color variant. Defaults to [AppBadgeVariant.primary].
  final AppBadgeVariant variant;

  /// Size variant. Defaults to [AppComponentSize.sm].
  final AppComponentSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final bgColor = switch (variant) {
      AppBadgeVariant.primary => colors.primary,
      AppBadgeVariant.success => colors.success,
      AppBadgeVariant.error => colors.error,
      AppBadgeVariant.warning => colors.warning,
      AppBadgeVariant.info => colors.info,
    };

    final fgColor = switch (variant) {
      AppBadgeVariant.warning => colors.textPrimary,
      _ => colors.onPrimary,
    };

    final (hPad, vPad, textStyle) = switch (size) {
      AppComponentSize.sm => (
        spacing.badgePaddingX,
        spacing.badgePaddingY,
        typography.caption,
      ),
      AppComponentSize.md => (spacing.s8, spacing.s4, typography.bodySmall),
      AppComponentSize.lg => (spacing.s12, spacing.s6, typography.body),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius.badge),
      ),
      child: Text(
        label,
        style: textStyle.copyWith(color: fgColor, height: 1.2),
      ),
    );
  }
}
