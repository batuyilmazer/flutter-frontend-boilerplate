import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// A themed loading spinner.
///
/// ```dart
/// AppSpinner()
/// AppSpinner(size: AppComponentSize.lg, color: Colors.red)
/// ```
class AppSpinner extends StatelessWidget {
  const AppSpinner({
    super.key,
    this.size = AppComponentSize.md,
    this.color,
    this.strokeWidth,
  });

  /// Size variant. Defaults to [AppComponentSize.md].
  final AppComponentSize size;

  /// Spinner color. Defaults to [AppColorScheme.primary].
  final Color? color;

  /// Stroke width. Defaults based on size.
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sizes = context.appSizes;

    final dimension = sizes.iconSize(size);
    final resolvedColor = color ?? colors.primary;
    final resolvedStroke =
        strokeWidth ??
        switch (size) {
          AppComponentSize.sm => 2.0,
          AppComponentSize.md => 3.0,
          AppComponentSize.lg => 4.0,
        };

    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator(
        strokeWidth: resolvedStroke,
        valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
      ),
    );
  }
}
