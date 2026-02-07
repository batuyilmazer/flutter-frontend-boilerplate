import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../route_paths.dart';

/// Route definitions for the authentication feature.
///
/// This module contains all routes related to authentication:
/// - Login
/// - Registration
class AuthRoutes {
  /// Get all authentication routes.
  ///
  /// Returns a list of RouteBase objects that can be used
  /// in the main router configuration.
  static List<RouteBase> get routes => [
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
  ];
}
