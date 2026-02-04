import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Button variants for different use cases.
enum AppButtonVariant { primary, secondary, outline, text }

/// Reusable button component that uses app theme tokens.
///
/// Provides consistent button styling across the app. Use variants to
/// differentiate button types (primary action, secondary, etc.).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);
    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildButton(BuildContext context) {
    final colors = context.appColors;
    final radius = context.appRadius;
    final spacing = context.appSpacing;

    if (isLoading) {
      return _buildLoadingButton(context);
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.medium),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s24,
              vertical: spacing.s12,
            ),
          ),
          child: _buildContent(),
        );
      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.surface,
            foregroundColor: colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.medium),
              side: BorderSide(color: colors.primary),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s24,
              vertical: spacing.s12,
            ),
          ),
          child: _buildContent(),
        );
      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.textPrimary,
            side: BorderSide(color: colors.textSecondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.medium),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s24,
              vertical: spacing.s12,
            ),
          ),
          child: _buildContent(),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s8,
            ),
          ),
          child: _buildContent(),
        );
    }
  }

  Widget _buildContent() {
    // Typography is only needed for Text widgets; pull it lazily via context
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Builder(
            builder: (context) =>
                Text(label, style: context.appTypography.button),
          ),
        ],
      );
    }
    return Builder(
      builder: (context) => Text(label, style: context.appTypography.button),
    );
  }

  Widget _buildLoadingButton(BuildContext context) {
    final colors = context.appColors;
    final radius = context.appRadius;
    final spacing = context.appSpacing;

    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: variant == AppButtonVariant.primary
            ? colors.primary
            : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.medium),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s24,
          vertical: spacing.s12,
        ),
      ),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary ? Colors.white : colors.primary,
          ),
        ),
      ),
    );
  }
}
