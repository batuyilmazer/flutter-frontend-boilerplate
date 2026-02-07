import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/auth_state.dart';
import '../route_paths.dart';

/// Authentication guard that handles route protection based on auth state.
///
/// Responsibilities:
/// - Redirect unauthenticated users to login
/// - Redirect authenticated users away from auth pages
/// - Handle loading states gracefully
class AuthGuard {
  /// Determines if a redirect is needed based on authentication state.
  ///
  /// Returns:
  /// - `null` if no redirect is needed
  /// - Route path (String) if redirect is required
  ///
  /// Behavior:
  /// - Loading state → no redirect (wait for auth check)
  /// - Unauthenticated + protected route → redirect to login
  /// - Authenticated + auth route → redirect to home
  static String? redirect(
    BuildContext context,
    GoRouterState state,
    AuthNotifier authNotifier,
  ) {
    final authState = authNotifier.state;
    final isLoggedIn = authNotifier.isAuthenticated;
    final currentPath = state.matchedLocation;

    // Check if current route is an auth route
    final isAuthRoute = _isAuthRoute(currentPath);

    // Check if current route is a protected route
    final isProtectedRoute = _isProtectedRoute(currentPath);

    // If still loading, don't redirect yet
    if (authState is AuthLoadingState) {
      return null;
    }

    // If not logged in and trying to access protected route
    if (!isLoggedIn && isProtectedRoute) {
      return AppRoutes.login;
    }

    // If logged in and trying to access auth routes
    if (isLoggedIn && isAuthRoute) {
      return AppRoutes.home;
    }

    return null; // No redirect needed
  }

  /// Check if the given path is an authentication route.
  static bool _isAuthRoute(String path) {
    return path == AppRoutes.login || path == AppRoutes.register;
  }

  /// Check if the given path is a protected route (requires auth).
  static bool _isProtectedRoute(String path) {
    // All routes except auth routes are protected by default
    return !_isAuthRoute(path);
  }
}
