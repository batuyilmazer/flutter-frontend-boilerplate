import 'package:flutter/material.dart';

/// Shadow scheme containing elevation / box-shadow tokens.
///
/// Provides consistent shadow values for cards, dialogs, popovers, etc.
class AppShadowScheme {
  const AppShadowScheme({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
  });

  /// No shadow
  final BoxShadow none;

  /// Small shadow (subtle elevation)
  final BoxShadow sm;

  /// Medium shadow (cards, dropdowns)
  final BoxShadow md;

  /// Large shadow (dialogs, modals)
  final BoxShadow lg;

  /// Convenience: get a [List<BoxShadow>] from a single shadow token.
  List<BoxShadow> list(BoxShadow shadow) => shadow == none ? [] : [shadow];
}

/// Default shadow scheme using neutral black with varying blur/offset.
class DefaultShadowScheme extends AppShadowScheme {
  const DefaultShadowScheme()
    : super(
        none: const BoxShadow(color: Color(0x00000000)),
        sm: const BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
        md: const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
        lg: const BoxShadow(
          color: Color(0x26000000),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      );
}
