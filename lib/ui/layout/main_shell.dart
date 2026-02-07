import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Configuration for a single tab in the shell layout.
///
/// This is intentionally simple so template consumers can:
/// - Change labels and icons
/// - Point tabs to different routes
/// - Add or remove tabs as needed
class ShellTabConfig {
  const ShellTabConfig({
    required this.label,
    required this.icon,
    required this.path,
  });

  /// Text label shown under the tab icon.
  final String label;

  /// Icon displayed for the tab.
  final IconData icon;

  /// Target route path for this tab.
  ///
  /// Typically one of the values from [AppRoutes],
  /// but can be any valid GoRouter location.
  final String path;
}

/// Generic shell layout that can host any set of tab routes.
///
/// This widget is intentionally minimal and opinionated only about:
/// - Having a [Scaffold]
/// - Rendering a [BottomNavigationBar] for the provided [tabs]
/// - Navigating via GoRouter when a tab is tapped
///
/// Everything else (which tabs exist, which routes they map to, etc.)
/// is decided by the routing layer and can be customized by template consumers.
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
    required this.tabs,
  });

  /// The active route content rendered in the scaffold body.
  final Widget child;

  /// Tab configuration for the bottom navigation bar.
  final List<ShellTabConfig> tabs;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final currentIndex = _resolveCurrentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
        ],
        onTap: (index) {
          final target = tabs[index];
          if (target.path != location) {
            context.go(target.path);
          }
        },
      ),
    );
  }

  /// Determine which tab should be marked as active for the given location.
  ///
  /// The default strategy is:
  /// - Exact match on [ShellTabConfig.path], or
  /// - First tab whose path is a prefix of the current location
  /// - Fallback to index 0 if no match is found
  int _resolveCurrentIndex(String location) {
    for (var i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      if (location == tab.path || location.startsWith('${tab.path}/')) {
        return i;
      }
    }
    return 0;
  }
}

