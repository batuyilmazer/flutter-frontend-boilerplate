import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// An empty state placeholder widget.
///
/// Shows an icon, title, description, and optional action button
/// when there is no data to display.
///
/// ```dart
/// AppEmpty(
///   icon: Icons.inbox_outlined,
///   title: 'No messages',
///   description: 'You have no messages yet.',
///   action: AppButton(label: 'Refresh', onPressed: _refresh),
/// )
/// ```
class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    this.icon,
    this.title,
    this.description,
    this.action,
    this.iconSize,
  });

  /// Large icon displayed at the top.
  final IconData? icon;

  /// Title text.
  final String? title;

  /// Description text.
  final String? description;

  /// Optional action widget (e.g. a button).
  final Widget? action;

  /// Icon size. Defaults to 64.
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize ?? 64, color: colors.textDisabled),
              SizedBox(height: spacing.s16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: typography.title.copyWith(color: colors.textPrimary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.s8),
            ],
            if (description != null) ...[
              Text(
                description!,
                style: typography.body.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.s24),
            ],
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}
