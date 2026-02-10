import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Alert variant for different semantic states.
enum AppAlertVariant { success, error, warning, info }

/// A themed inline alert / banner.
///
/// Displays a message with an optional icon, action button, and dismiss.
///
/// ```dart
/// AppAlert(
///   message: 'Operation completed successfully!',
///   variant: AppAlertVariant.success,
/// )
/// ```
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.message,
    this.variant = AppAlertVariant.info,
    this.title,
    this.icon,
    this.action,
    this.onDismiss,
  });

  /// The alert message body.
  final String message;

  /// Semantic variant. Defaults to info.
  final AppAlertVariant variant;

  /// Optional title text displayed above the message.
  final String? title;

  /// Custom icon override. Auto-selected by variant if not provided.
  final IconData? icon;

  /// Optional action button widget.
  final Widget? action;

  /// Called when the dismiss button is tapped. If null, no dismiss button is shown.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final (accentColor, defaultIcon) = switch (variant) {
      AppAlertVariant.success => (colors.success, Icons.check_circle_outline),
      AppAlertVariant.error => (colors.error, Icons.error_outline),
      AppAlertVariant.warning => (colors.warning, Icons.warning_amber_outlined),
      AppAlertVariant.info => (colors.info, Icons.info_outline),
    };

    final resolvedIcon = icon ?? defaultIcon;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius.medium),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(resolvedIcon, color: accentColor, size: 20),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: typography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: spacing.s4),
                ],
                Text(
                  message,
                  style: typography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                if (action != null) ...[SizedBox(height: spacing.s12), action!],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: spacing.s8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, color: colors.textSecondary, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}
