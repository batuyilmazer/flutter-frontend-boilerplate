import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A single context menu item.
class AppContextMenuItem {
  const AppContextMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
  });

  /// Menu item label.
  final String label;

  /// Called when the item is tapped.
  final VoidCallback onTap;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether this is a destructive action (shown in error color).
  final bool isDestructive;

  /// Whether this item is interactive.
  final bool enabled;
}

/// A divider item for separating groups in a context menu.
class AppContextMenuDivider extends AppContextMenuItem {
  AppContextMenuDivider() : super(label: '', onTap: () {});
}

/// A themed context menu triggered by long-press or right-click.
///
/// ```dart
/// AppContextMenu(
///   items: [
///     AppContextMenuItem(label: 'Edit', icon: Icons.edit, onTap: _edit),
///     AppContextMenuItem(label: 'Copy', icon: Icons.copy, onTap: _copy),
///     AppContextMenuDivider(),
///     AppContextMenuItem(label: 'Delete', icon: Icons.delete, onTap: _delete, isDestructive: true),
///   ],
///   child: ListTile(title: Text('Long press me')),
/// )
/// ```
class AppContextMenu extends StatelessWidget {
  const AppContextMenu({super.key, required this.items, required this.child});

  /// The menu items to display.
  final List<AppContextMenuItem> items;

  /// The widget that triggers the context menu on long-press.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _showMenu(context, details.globalPosition),
      onSecondaryTapUp: (details) => _showMenu(context, details.globalPosition),
      child: child,
    );
  }

  void _showMenu(BuildContext context, Offset position) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final menuItems = <PopupMenuEntry<int>>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      if (item is AppContextMenuDivider) {
        menuItems.add(PopupMenuDivider(height: 1));
        continue;
      }

      menuItems.add(
        PopupMenuItem<int>(
          value: i,
          enabled: item.enabled,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s16,
            vertical: spacing.s4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 18,
                  color: item.isDestructive
                      ? colors.error
                      : (item.enabled
                            ? colors.textPrimary
                            : colors.textDisabled),
                ),
                SizedBox(width: spacing.s12),
              ],
              Text(
                item.label,
                style: typography.body.copyWith(
                  color: item.isDestructive
                      ? colors.error
                      : (item.enabled
                            ? colors.textPrimary
                            : colors.textDisabled),
                ),
              ),
            ],
          ),
        ),
      );
    }

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: menuItems,
      color: colors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.contextMenu),
        side: BorderSide(color: colors.border),
      ),
    ).then((index) {
      if (index != null && index < items.length) {
        items[index].onTap();
      }
    });
  }
}
