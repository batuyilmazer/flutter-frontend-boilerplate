import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/home_screen.dart';
import '../../ui/layout/main_shell.dart';
import '../route_paths.dart';

/// Route definitions for the shell-based layout (e.g. bottom navigation).
///
/// This builder groups authenticated routes under a [ShellRoute] so that
/// they share a common layout while keeping feature routes modular.
class ShellRoutes {
  /// Get all routes that should be hosted inside the shell layout.
  ///
  /// Template consumers can adjust which routes live under the shell by:
  /// - Changing the tab configuration in [_buildShellTabs]
  /// - Adding more nested [GoRoute]s for new features
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) =>
          MainShell(tabs: _buildShellTabs(), child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
  ];

  /// Default tab configuration for the shell layout.
  ///
  /// This is intentionally small and opinionated, but can be modified or
  /// replaced by template consumers to fit their navigation needs.
  static List<ShellTabConfig> _buildShellTabs() => const [
    ShellTabConfig(label: 'Home', icon: Icons.home, path: AppRoutes.home),
  ];
}
