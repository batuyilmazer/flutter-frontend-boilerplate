import 'package:flutter/foundation.dart';
import '../../../core/errors/errors.dart';
import '../../../core/models/user/models.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

/// Notifier that manages authentication state across the app.
///
/// Provides methods for login, register, logout, and session restoration.
/// Notifies listeners when auth state changes.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        _state = const AuthLoadingState() {
    _initialize();
  }

  final AuthRepository _authRepository;
  AuthState _state;

  /// Current authentication state.
  AuthState get state => _state;

  /// Current user if authenticated, null otherwise.
  User? get currentUser {
    final state = _state;
    return state is AuthenticatedState ? state.user : null;
  }

  /// Whether user is currently authenticated.
  bool get isAuthenticated => _state is AuthenticatedState;

  /// Whether an auth operation is in progress.
  bool get isLoading => _state is AuthLoadingState;

  /// Initialize auth state by checking for existing session.
  Future<void> _initialize() async {
    try {
      final user = await _authRepository.restoreSession();
      if (user != null) {
        _state = AuthenticatedState(user);
      } else {
        _state = const UnauthenticatedState();
      }
    } catch (e) {
      _state = const UnauthenticatedState();
    } finally {
      notifyListeners();
    }
  }

  /// Register a new user.
  Future<void> register({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
      );
      result.when(
        success: (user) {
          _state = AuthenticatedState(user);
          notifyListeners();
        },
        failure: _handleFailure,
      );
    } catch (e) {
      _handleFailure(ErrorMapper.mapException(e));
    }
  }

  /// Login with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );
      result.when(
        success: (user) {
          _state = AuthenticatedState(user);
          notifyListeners();
        },
        failure: _handleFailure,
      );
    } catch (e) {
      _handleFailure(ErrorMapper.mapException(e));
    }
  }

  /// Logout from current session.
  Future<void> logout() async {
    _setLoading();
    try {
      await _authRepository.logout();
      _state = const UnauthenticatedState();
      notifyListeners();
    } catch (e) {
      // Even if logout fails, clear local state
      _state = const UnauthenticatedState();
      notifyListeners();
    }
  }

  /// Logout from all devices.
  Future<void> logoutAll() async {
    _setLoading();
    try {
      await _authRepository.logoutAll();
      _state = const UnauthenticatedState();
      notifyListeners();
    } catch (e) {
      // Even if logout fails, clear local state
      _state = const UnauthenticatedState();
      notifyListeners();
    }
  }

  /// Refresh current user info from backend.
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;

    try {
      // Reuse restoreSession logic to fetch fresh user data from /me
      final user = await _authRepository.restoreSession();
      if (user != null) {
        _state = AuthenticatedState(user);
        notifyListeners();
      } else {
        // Session could not be restored, treat as logged out
        await logout();
      }
    } catch (e) {
      // If refresh fails, logout user
      await logout();
    }
  }

  /// Clear error state and return to previous state.
  void clearError() {
    if (_state is AuthErrorState) {
      _state = const UnauthenticatedState();
      notifyListeners();
    }
  }

  void _setLoading() {
    _state = const AuthLoadingState();
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    final message = switch (failure) {
      SessionExpiredFailure _ =>
        'Session expired. Please login again.',
      InvalidCredentialsFailure _ => failure.message,
      ConnectionFailure _ =>
        'No internet connection. Please check your network.',
      TimeoutFailure _ =>
        'Request timed out. Please try again.',
      _ => failure.message,
    };
    _state = AuthErrorState(message, failure: failure);
    notifyListeners();
  }
}

