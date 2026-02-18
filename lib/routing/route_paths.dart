/// Centralized route paths for the entire application.
///
/// All route paths should be defined here to ensure consistency
/// and prevent typos. Use these constants throughout the app
/// instead of hardcoded strings.
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const login = '/login';
  static const register = '/register';

  // Profile routes
  static const home = '/';
  static const profile = '/profile';
  static const components = '/components';
}
