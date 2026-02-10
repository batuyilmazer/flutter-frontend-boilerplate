import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Side from which the drawer slides in.
enum AppDrawerPosition { left, right }

/// A themed side drawer.
///
/// Can be used as a [Scaffold.drawer] or [Scaffold.endDrawer].
///
/// ```dart
/// Scaffold(
///   drawer: AppDrawer(
///     child: ListView(children: [Text('Menu items')]),
///   ),
/// )
/// ```
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.child,
    this.width,
    this.header,
    this.footer,
    this.backgroundColor,
  });

  /// The drawer content.
  final Widget child;

  /// Drawer width. Defaults to 280.
  final double? width;

  /// Optional header widget displayed at the top.
  final Widget? header;

  /// Optional footer widget displayed at the bottom.
  final Widget? footer;

  /// Background color. Defaults to [AppColorScheme.surface].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;

    return SizedBox(
      width: width ?? 280,
      child: Drawer(
        backgroundColor: backgroundColor ?? colors.surface,
        child: Column(
          children: [
            if (header != null)
              Padding(padding: EdgeInsets.all(spacing.s16), child: header!),
            Expanded(child: child),
            if (footer != null)
              Padding(padding: EdgeInsets.all(spacing.s16), child: footer!),
          ],
        ),
      ),
    );
  }
}
