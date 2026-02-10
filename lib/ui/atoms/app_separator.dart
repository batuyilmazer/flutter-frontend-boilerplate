import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed separator / divider line.
///
/// Supports horizontal and vertical orientations with optional indent.
///
/// ```dart
/// AppSeparator()                         // horizontal
/// AppSeparator(direction: Axis.vertical) // vertical
/// ```
class AppSeparator extends StatelessWidget {
  const AppSeparator({
    super.key,
    this.direction = Axis.horizontal,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.height,
  });

  /// Orientation of the separator. Defaults to horizontal.
  final Axis direction;

  /// Line thickness. Defaults to 1.
  final double? thickness;

  /// Line color. Defaults to [AppColorScheme.border].
  final Color? color;

  /// Leading indent. Defaults to 0.
  final double? indent;

  /// Trailing indent. Defaults to 0.
  final double? endIndent;

  /// Total space occupied (including whitespace around the line).
  /// Defaults to thickness.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.appColors.border;
    final resolvedThickness = thickness ?? 1;

    if (direction == Axis.vertical) {
      return Container(
        width: height ?? resolvedThickness,
        margin: EdgeInsets.only(top: indent ?? 0, bottom: endIndent ?? 0),
        color: resolvedColor,
      );
    }

    return Divider(
      thickness: resolvedThickness,
      color: resolvedColor,
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
      height: height ?? resolvedThickness,
    );
  }
}
