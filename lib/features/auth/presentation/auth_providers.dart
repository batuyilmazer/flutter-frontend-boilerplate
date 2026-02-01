import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_repository.dart';
import 'auth_notifier.dart';

/// Provider widget for [AuthNotifier] that manages authentication state.
///
/// Wrap your app with this provider to make auth state available throughout the app.
///
/// Usage:
/// ```dart
/// ChangeNotifierProvider(
///   create: (_) => AuthNotifier(),
///   child: MyApp(),
/// )
/// ```
class AuthNotifierProvider extends ChangeNotifierProvider<AuthNotifier> {
  AuthNotifierProvider({
    super.key,
    AuthRepository? authRepository,
    required super.child,
  }) : super(
          create: (_) => AuthNotifier(authRepository: authRepository),
        );
}

/// Extension to easily access AuthNotifier from BuildContext.
extension AuthNotifierExtension on BuildContext {
  /// Get AuthNotifier without listening to changes.
  AuthNotifier get authNotifier => Provider.of<AuthNotifier>(this, listen: false);
  
  /// Watch AuthNotifier and rebuild when state changes.
  AuthNotifier watchAuthNotifier() => Provider.of<AuthNotifier>(this);
}

