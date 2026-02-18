/// Semantic component size.
///
/// Used by components that support multiple sizes (buttons, inputs, avatars, etc.)
enum AppComponentSize { sm, md, lg }

/// Size scheme containing component-level dimension tokens.
///
/// Provides consistent height/width values for buttons, inputs, avatars,
/// and icons across the app.
class AppSizeScheme {
  const AppSizeScheme({
    required this.iconSm,
    required this.iconMd,
    required this.iconLg,
    required this.buttonHeightSm,
    required this.buttonHeightMd,
    required this.buttonHeightLg,
    required this.inputHeightSm,
    required this.inputHeightMd,
    required this.inputHeightLg,
    required this.avatarSm,
    required this.avatarMd,
    required this.avatarLg,
  });

  /// Small icon size (16px)
  final double iconSm;

  /// Medium icon size (24px)
  final double iconMd;

  /// Large icon size (32px)
  final double iconLg;

  /// Small button height (32px)
  final double buttonHeightSm;

  /// Medium button height (40px)
  final double buttonHeightMd;

  /// Large button height (48px)
  final double buttonHeightLg;

  /// Small input height (32px)
  final double inputHeightSm;

  /// Medium input height (40px)
  final double inputHeightMd;

  /// Large input height (48px)
  final double inputHeightLg;

  /// Small avatar size (24px)
  final double avatarSm;

  /// Medium avatar size (40px)
  final double avatarMd;

  /// Large avatar size (56px)
  final double avatarLg;

  /// Resolve icon size from [AppComponentSize].
  double iconSize(AppComponentSize size) => switch (size) {
    AppComponentSize.sm => iconSm,
    AppComponentSize.md => iconMd,
    AppComponentSize.lg => iconLg,
  };

  /// Resolve button height from [AppComponentSize].
  double buttonHeight(AppComponentSize size) => switch (size) {
    AppComponentSize.sm => buttonHeightSm,
    AppComponentSize.md => buttonHeightMd,
    AppComponentSize.lg => buttonHeightLg,
  };

  /// Resolve input height from [AppComponentSize].
  double inputHeight(AppComponentSize size) => switch (size) {
    AppComponentSize.sm => inputHeightSm,
    AppComponentSize.md => inputHeightMd,
    AppComponentSize.lg => inputHeightLg,
  };

  /// Resolve avatar size from [AppComponentSize].
  double avatarSize(AppComponentSize size) => switch (size) {
    AppComponentSize.sm => avatarSm,
    AppComponentSize.md => avatarMd,
    AppComponentSize.lg => avatarLg,
  };
}

/// Default size scheme implementation.
class DefaultSizeScheme extends AppSizeScheme {
  const DefaultSizeScheme()
    : super(
        iconSm: 16,
        iconMd: 24,
        iconLg: 32,
        buttonHeightSm: 40,
        buttonHeightMd: 56,
        buttonHeightLg: 72,
        inputHeightSm: 32,
        inputHeightMd: 40,
        inputHeightLg: 48,
        avatarSm: 24,
        avatarMd: 40,
        avatarLg: 56,
      );
}
