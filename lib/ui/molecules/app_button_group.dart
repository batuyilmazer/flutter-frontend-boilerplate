import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A group of buttons laid out in a row or column with consistent spacing.
///
/// ```dart
/// AppButtonGroup(
///   children: [
///     AppButton(label: 'Save', onPressed: _save),
///     AppButton(label: 'Cancel', onPressed: _cancel, variant: AppButtonVariant.outline),
///   ],
/// )
/// ```
class AppButtonGroup extends StatelessWidget {
  const AppButtonGroup({
    super.key,
    required this.children,
    this.direction = Axis.horizontal,
    this.spacing,
    this.alignment = MainAxisAlignment.start,
    this.crossAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// The button widgets to display.
  final List<Widget> children;

  /// Layout direction. Defaults to horizontal.
  final Axis direction;

  /// Spacing between buttons. Defaults to [AppSpacingScheme.s8].
  final double? spacing;

  /// Main axis alignment.
  final MainAxisAlignment alignment;

  /// Cross axis alignment.
  final CrossAxisAlignment crossAlignment;

  /// Main axis size.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final resolvedSpacing = spacing ?? context.appSpacing.s8;

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: alignment,
        crossAxisAlignment: crossAlignment,
        children: _intersperse(SizedBox(width: resolvedSpacing), children),
      );
    }

    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: alignment,
      crossAxisAlignment: crossAlignment,
      children: _intersperse(SizedBox(height: resolvedSpacing), children),
    );
  }

  List<Widget> _intersperse(Widget separator, List<Widget> items) {
    if (items.isEmpty) return items;
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}
