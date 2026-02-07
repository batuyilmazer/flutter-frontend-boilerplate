import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/presentation/auth_notifier.dart';
import 'route_paths.dart';
import 'guards/auth_guard.dart';
import 'builders/auth_routes.dart';
import 'builders/profile_routes.dart';
import 'builders/shell_routes.dart';

/// Available routing modes for the application.
///
/// - [RoutingMode.plain]: Use feature routes directly (no shell layout).
/// - [RoutingMode.shell]: Host authenticated area inside a ShellRoute-based
///   layout (e.g. bottom navigation).
enum RoutingMode {
  plain,
  shell,
}

/// Main application router configuration.
///
/// This class orchestrates all route modules and applies
/// global guards and middleware.
class AppRouter {
  /// Creates and configures the GoRouter instance.
  ///
  /// Parameters:
  /// - `context`: BuildContext to access providers
  /// - `mode`: Selects which routing mode to use. Defaults to [RoutingMode.plain].
  ///
  /// Returns configured GoRouter instance ready to use.
  static GoRouter createRouter(
    BuildContext context, {
    RoutingMode mode = RoutingMode.plain,
  }) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    return GoRouter(
      // Initial route when app starts
      initialLocation: AppRoutes.login,

      // Global redirect logic (auth guard)
      redirect: (context, state) =>
          AuthGuard.redirect(context, state, authNotifier),

      // Refresh router when auth state changes
      refreshListenable: authNotifier,

      // Combine all feature routes depending on routing mode
      routes: [
        ...AuthRoutes.routes,
        if (mode == RoutingMode.plain) ...ProfileRoutes.routes,
        if (mode == RoutingMode.shell) ...ShellRoutes.routes,
      ],

      // Global error handler
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
    );
  }
}
