import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed bottom sheet with static helper methods.
///
/// ```dart
/// AppSheet.show(
///   context,
///   child: Column(children: [Text('Sheet content')]),
/// );
/// ```
class AppSheet {
  const AppSheet._();

  /// Show a modal bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      isScrollControlled: isScrollControlled || height != null,
      backgroundColor: backgroundColor ?? colors.surface,
      barrierColor: colors.overlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.sheet)),
      ),
      builder: (ctx) {
        Widget content = Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.s16,
            showDragHandle ? spacing.s0 : spacing.s16,
            spacing.s16,
            spacing.s16,
          ),
          child: child,
        );

        if (height != null) {
          content = SizedBox(height: height, child: content);
        }

        return content;
      },
    );
  }
}
