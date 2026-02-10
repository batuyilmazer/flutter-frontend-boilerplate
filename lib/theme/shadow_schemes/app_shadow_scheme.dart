import 'package:flutter/material.dart';

/// Shadow scheme containing elevation / box-shadow tokens.
///
/// Provides consistent shadow values for cards, dialogs, popovers, etc.
class AppShadowScheme {
  const AppShadowScheme({
    // Primitive shadow tokens
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,

    // Semantic / component-level shadow tokens
    required this.card,
    required this.popover,
    required this.toast,
    required this.contextMenu,
    required this.elevatedButton,
    required this.toggleSelected,
  });

  /// No shadow
  final BoxShadow none;

  /// Small shadow (subtle elevation)
  final BoxShadow sm;

  /// Medium shadow (cards, dropdowns)
  final BoxShadow md;

  /// Large shadow (dialogs, modals)
  final BoxShadow lg;

  // --- Semantic / component-level shadow tokens ---

  /// Default shadow for cards / surfaces.
  final BoxShadow card;

  /// Default shadow for popovers.
  final BoxShadow popover;

  /// Default shadow for toasts / snackbars.
  final BoxShadow toast;

  /// Default shadow for context menus.
  final BoxShadow contextMenu;

  /// Default shadow for elevated buttons.
  final BoxShadow elevatedButton;

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

        // Semantics (defaults map to primitives)
        card: const BoxShadow(color: Color(0x00000000)),
        popover: const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
        toast: const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
        contextMenu: const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
        elevatedButton: const BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
        toggleSelected: const BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      );
}
