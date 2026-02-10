import 'package:flutter/material.dart';

import '../spacing_schemes/app_spacing_scheme.dart';

/// Convenience extensions on [AppSpacingScheme] for quick [EdgeInsets] creation.
///
/// Example:
/// ```dart
/// final spacing = context.appSpacing;
/// Padding(padding: spacing.insetAll(spacing.s16));
/// ```
extension SpacingEdgeInsets on AppSpacingScheme {
  /// Uniform padding on all sides.
  EdgeInsets insetAll(double v) => EdgeInsets.all(v);

  /// Symmetric horizontal padding.
  EdgeInsets insetHorizontal(double v) => EdgeInsets.symmetric(horizontal: v);

  /// Symmetric vertical padding.
  EdgeInsets insetVertical(double v) => EdgeInsets.symmetric(vertical: v);

  /// Symmetric padding with separate horizontal and vertical values.
  EdgeInsets insetSymmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Only specific sides.
  EdgeInsets insetOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
