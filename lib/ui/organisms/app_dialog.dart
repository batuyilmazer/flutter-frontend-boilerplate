import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed dialog with static helper methods for easy invocation.
///
/// Use [AppDialog.show] for a custom dialog or [AppAlertDialog.show] for a
/// simple confirm/cancel alert.
class AppDialog {
  const AppDialog._();

  /// Show a custom dialog.
  ///
  /// ```dart
  /// AppDialog.show(
  ///   context,
  ///   title: 'Custom Dialog',
  ///   content: MyCustomWidget(),
  ///   actions: [
  ///     AppButton(label: 'Close', onPressed: () => Navigator.pop(context)),
  ///   ],
  /// );
  /// ```
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: colors.overlay,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.large),
          ),
          backgroundColor: colors.surface,
          child: Padding(
            padding: EdgeInsets.all(spacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: typography.title.copyWith(color: colors.textPrimary),
                  ),
                  SizedBox(height: spacing.s16),
                ],
                content,
                if (actions != null && actions.isNotEmpty) ...[
                  SizedBox(height: spacing.s24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions
                        .expand((a) => [SizedBox(width: spacing.s8), a])
                        .skip(1)
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A themed alert dialog with confirm/cancel actions.
class AppAlertDialog {
  const AppAlertDialog._();

  /// Show a simple alert dialog with confirm and optional cancel buttons.
  ///
  /// Returns `true` if confirmed, `false` or `null` otherwise.
  ///
  /// ```dart
  /// final confirmed = await AppAlertDialog.show(
  ///   context,
  ///   title: 'Delete item?',
  ///   message: 'This action cannot be undone.',
  ///   confirmLabel: 'Delete',
  ///   cancelLabel: 'Cancel',
  /// );
  /// ```
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String? cancelLabel,
    VoidCallback? onConfirm,
    bool isDestructive = false,
  }) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    return showDialog<bool>(
      context: context,
      barrierColor: colors.overlay,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.large),
          ),
          backgroundColor: colors.surface,
          title: Text(
            title,
            style: typography.title.copyWith(color: colors.textPrimary),
          ),
          content: Text(
            message,
            style: typography.body.copyWith(color: colors.textSecondary),
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: spacing.s16,
            vertical: spacing.s12,
          ),
          actions: [
            if (cancelLabel != null)
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  cancelLabel,
                  style: typography.button.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.of(ctx).pop(true);
              },
              child: Text(
                confirmLabel,
                style: typography.button.copyWith(
                  color: isDestructive ? colors.error : colors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
