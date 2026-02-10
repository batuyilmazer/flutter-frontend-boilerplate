import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/shadow_schemes/app_shadow_scheme.dart';

/// A themed card component with configurable padding, radius, shadow, and border.
///
/// Wraps its [child] in a styled container using app theme tokens.
///
/// ```dart
/// AppCard(
///   padding: EdgeInsets.all(context.appSpacing.s16),
///   child: Text('Card content'),
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.shadow,
    this.width,
    this.height,
    this.onTap,
  });

  /// The widget below this card in the tree.
  final Widget child;

  /// Inner padding. Defaults to [AppSpacingScheme.s16] on all sides.
  final EdgeInsetsGeometry? padding;

  /// Outer margin. Defaults to none.
  final EdgeInsetsGeometry? margin;

  /// Background color. Defaults to [AppColorScheme.surface].
  final Color? color;

  /// Border color. Defaults to [AppColorScheme.border].
  final Color? borderColor;

  /// Corner radius. Defaults to [AppRadiusScheme.medium].
  final double? borderRadius;

  /// Shadow token. Defaults to [AppShadowScheme.none].
  final BoxShadow? shadow;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Optional tap callback (makes the card interactive).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final shadows = context.appShadows;

    final resolvedShadow = shadow ?? shadows.none;
    final resolvedRadius = borderRadius ?? radius.medium;

    final container = Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(spacing.s16),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: Border.all(color: borderColor ?? colors.border),
        boxShadow: shadows.list(resolvedShadow),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
