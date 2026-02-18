import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

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
    this.size = AppComponentSize.md,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
   /// Semantic size for the button (sm, md, lg).
  final AppComponentSize size;
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
    final spacing = context.appSpacing;
    final sizes = context.appSizes;
    final theme = Theme.of(context);

    final buttonHeight = sizes.buttonHeight(size);

    EdgeInsets primaryPadding() {
      switch (size) {
        case AppComponentSize.sm:
          return EdgeInsets.symmetric(
            horizontal: spacing.buttonPaddingX * 0.75,
            vertical: spacing.buttonPaddingY * 0.75,
          );
        case AppComponentSize.lg:
          return EdgeInsets.symmetric(
            horizontal: spacing.buttonPaddingX * 1.25,
            vertical: spacing.buttonPaddingY * 1.25,
          );
        case AppComponentSize.md:
          return EdgeInsets.symmetric(
            horizontal: spacing.buttonPaddingX,
            vertical: spacing.buttonPaddingY,
          );
      }
    }

    EdgeInsets textPadding() {
      switch (size) {
        case AppComponentSize.sm:
          return EdgeInsets.symmetric(
            horizontal: spacing.s12,
            vertical: spacing.s4,
          );
        case AppComponentSize.lg:
          return EdgeInsets.symmetric(
            horizontal: spacing.s16 * 1.25,
            vertical: spacing.s8 * 1.25,
          );
        case AppComponentSize.md:
          return EdgeInsets.symmetric(
            horizontal: spacing.s16,
            vertical: spacing.s8,
          );
      }
    }

    if (isLoading) {
      return _buildLoadingButton(context);
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: theme.elevatedButtonTheme.style?.copyWith(
            minimumSize: WidgetStateProperty.all(
              Size(0, buttonHeight),
            ),
            padding: WidgetStateProperty.all(primaryPadding()),
          ),
          child: _buildContent(),
        );
      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: onPressed,
          style: theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStatePropertyAll(colors.surfaceVariant),
            foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
            side: WidgetStatePropertyAll(
              BorderSide(color: colors.border),
            ),
            minimumSize: WidgetStateProperty.all(
              Size(0, buttonHeight),
            ),
            padding: WidgetStateProperty.all(primaryPadding()),
          ),
          child: _buildContent(),
        );
      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: theme.outlinedButtonTheme.style?.copyWith(
            foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
            side: WidgetStatePropertyAll(
              BorderSide(color: colors.border),
            ),
            minimumSize: WidgetStateProperty.all(
              Size(0, buttonHeight),
            ),
            padding: WidgetStateProperty.all(primaryPadding()),
          ),
          child: _buildContent(),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: theme.textButtonTheme.style?.copyWith(
            foregroundColor: WidgetStatePropertyAll(colors.primary),
            minimumSize: WidgetStateProperty.all(
              Size(0, buttonHeight),
            ),
            padding: WidgetStateProperty.all(textPadding()),
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
    final spacing = context.appSpacing;
    final sizes = context.appSizes;
    final theme = Theme.of(context);

    final buttonHeight = sizes.buttonHeight(size);

    return ElevatedButton(
      onPressed: null,
      style: theme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(
          variant == AppButtonVariant.primary
              ? colors.primary
              : colors.surface,
        ),
        minimumSize: WidgetStateProperty.all(
          Size(0, buttonHeight),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: spacing.buttonPaddingX,
            vertical: spacing.buttonPaddingY,
          ),
        ),
      ),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? colors.onPrimary
                : colors.primary,
          ),
        ),
      ),
    );
  }
}
