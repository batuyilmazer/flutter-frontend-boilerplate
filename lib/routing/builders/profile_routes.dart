import 'package:go_router/go_router.dart';
import '../../features/profile/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../route_paths.dart';

/// Route definitions for the profile feature.
class ProfileRoutes {
  /// Get all profile routes.
  ///
  /// Returns a list of RouteBase objects that can be used
  /// in the main router configuration.
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ];
}
