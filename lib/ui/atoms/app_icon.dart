import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Icon size variants for consistent sizing.
enum AppIconSize {
  small(16),
  medium(24),
  large(32),
  xlarge(48);

  const AppIconSize(this.size);
  final double size;
}

/// Reusable icon component that uses app theme tokens.
///
/// Provides consistent icon sizing and coloring across the app.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final AppIconSize size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size.size,
      color: color ?? context.appColors.textPrimary,
      semanticLabel: semanticLabel,
    );
  }
}

