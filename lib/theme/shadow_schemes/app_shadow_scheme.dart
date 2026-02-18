import 'package:flutter/material.dart';

/// Shadow scheme containing elevation / box-shadow tokens.
///
/// Provides consistent shadow values for cards, dialogs, popovers, etc.
class AppShadowScheme {
  const AppShadowScheme({
    required this.none,
    required this.popover,
    required this.toggleSelected,
  });

  /// No shadow
  final BoxShadow none;

  /// Default shadow for popovers.
  final BoxShadow popover;

  /// Default shadow for selected toggle items.
  final BoxShadow toggleSelected;

  /// Convenience: get a [List<BoxShadow>] from a single shadow token.
  List<BoxShadow> list(BoxShadow shadow) => shadow == none ? [] : [shadow];
}

/// Default shadow scheme using neutral black with varying blur/offset.
class DefaultShadowScheme extends AppShadowScheme {
  const DefaultShadowScheme()
    : super(
        none: const BoxShadow(color: Color(0x00000000)),
        popover: const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
        toggleSelected: const BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      );
}
