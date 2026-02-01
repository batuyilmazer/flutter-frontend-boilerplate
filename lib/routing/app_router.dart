import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/auth_notifier.dart';
import '../features/auth/presentation/auth_state.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/profile/presentation/home_screen.dart';

/// Route paths used throughout the app.
class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const register = '/register';
  static const home = '/';
}

/// App router configuration with auth guards.
///
/// Automatically redirects based on authentication state:
/// - Unauthenticated users → /login
/// - Authenticated users → /home
class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) {
        final authState = authNotifier.state;
        final isLoggedIn = authNotifier.isAuthenticated;
        final isLoggingIn = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register;

        // If still loading, don't redirect yet
        if (authState is AuthLoadingState) {
          return null;
        }

        // If not logged in and trying to access protected route
        if (!isLoggedIn && !isLoggingIn) {
          return AppRoutes.login;
        }

        // If logged in and trying to access auth routes
        if (isLoggedIn && isLoggingIn) {
          return AppRoutes.home;
        }

        return null; // No redirect needed
      },
      refreshListenable: authNotifier,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.uri}'),
        ),
      ),
    );
  }
}

