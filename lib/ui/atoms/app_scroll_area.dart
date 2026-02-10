import 'package:flutter/material.dart';

/// A themed scrollable area with an optional scrollbar.
///
/// ```dart
/// AppScrollArea(
///   child: Column(children: longList),
/// )
/// ```
class AppScrollArea extends StatelessWidget {
  const AppScrollArea({
    super.key,
    required this.child,
    this.direction = Axis.vertical,
    this.showScrollbar = true,
    this.controller,
    this.padding,
  });

  /// The scrollable content.
  final Widget child;

  /// Scroll direction. Defaults to vertical.
  final Axis direction;

  /// Whether to show a scrollbar thumb. Defaults to true.
  final bool showScrollbar;

  /// Optional scroll controller.
  final ScrollController? controller;

  /// Optional padding inside the scrollable area.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      scrollDirection: direction,
      controller: controller,
      padding: padding,
      child: child,
    );

    if (showScrollbar) {
      return Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: scrollView,
      );
    }

    return scrollView;
  }
}
