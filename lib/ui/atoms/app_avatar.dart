import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// Avatar shape.
enum AppAvatarShape { circle, rounded }

/// A user avatar that displays an image or initials.
///
/// ```dart
/// AppAvatar(initials: 'JD', size: AppComponentSize.md)
/// AppAvatar(imageUrl: 'https://...', size: AppComponentSize.lg)
/// ```
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AppComponentSize.md,
    this.shape = AppAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Network image URL. Takes priority over [initials].
  final String? imageUrl;

  /// Initials to display when no image is provided (e.g. "JD").
  final String? initials;

  /// Size variant. Defaults to [AppComponentSize.md].
  final AppComponentSize size;

  /// Shape variant. Defaults to [AppAvatarShape.circle].
  final AppAvatarShape shape;

  /// Background color. Defaults to [AppColorScheme.primary].
  final Color? backgroundColor;

  /// Text / icon color. Defaults to white.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sizes = context.appSizes;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final dimension = sizes.avatarSize(size);
    final bgColor = backgroundColor ?? colors.primary;
    final fgColor = foregroundColor ?? colors.onPrimary;

    final borderRadius = shape == AppAvatarShape.circle
        ? BorderRadius.circular(radius.full)
        : BorderRadius.circular(radius.avatar);

    final textStyle = switch (size) {
      AppComponentSize.sm => typography.caption,
      AppComponentSize.md => typography.bodySmall,
      AppComponentSize.lg => typography.title,
    };

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                (initials ?? '?').substring(
                  0,
                  initials != null && initials!.length >= 2
                      ? 2
                      : (initials?.length ?? 1),
                ),
                style: textStyle.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
