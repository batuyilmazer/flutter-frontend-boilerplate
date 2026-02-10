import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Toast color variant.
enum AppToastVariant { success, error, warning, info }

/// A themed toast / snackbar notification.
///
/// ```dart
/// AppToast.show(context, message: 'Saved!', variant: AppToastVariant.success);
/// ```
class AppToast {
  const AppToast._();

  /// Show a toast message.
  static void show(
    BuildContext context, {
    required String message,
    AppToastVariant variant = AppToastVariant.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final bgColor = switch (variant) {
      AppToastVariant.success => colors.success,
      AppToastVariant.error => colors.error,
      AppToastVariant.warning => colors.warning,
      AppToastVariant.info => colors.info,
    };

    final fgColor = switch (variant) {
      AppToastVariant.warning => colors.textPrimary,
      _ => colors.onPrimary,
    };

    final icon = switch (variant) {
      AppToastVariant.success => Icons.check_circle_outline,
      AppToastVariant.error => Icons.error_outline,
      AppToastVariant.warning => Icons.warning_amber_outlined,
      AppToastVariant.info => Icons.info_outline,
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.toast),
          ),
          margin: EdgeInsets.all(spacing.s16),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.toastPaddingX,
            vertical: spacing.toastPaddingY,
          ),
          content: Row(
            children: [
              Icon(icon, color: fgColor, size: 20),
              SizedBox(width: spacing.s8),
              Expanded(
                child: Text(
                  message,
                  style: typography.body.copyWith(color: fgColor),
                ),
              ),
            ],
          ),
          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: fgColor,
                  onPressed: onAction ?? () {},
                )
              : null,
        ),
      );
  }
}
