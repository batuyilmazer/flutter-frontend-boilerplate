import '../../../core/models/user.dart';

/// Represents the current authentication state of the app.
sealed class AuthState {
  const AuthState();
}

/// User is not authenticated (logged out).
class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

/// User is authenticated and logged in.
class AuthenticatedState extends AuthState {
  const AuthenticatedState(this.user);

  final User user;
}

/// Authentication operation is in progress (loading).
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// Authentication operation failed with an error.
class AuthErrorState extends AuthState {
  const AuthErrorState(this.message);

  final String message;
}

