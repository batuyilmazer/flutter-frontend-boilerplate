import 'user.dart';

/// Computed properties and utility methods for [User].
extension UserStatusExtension on User {
  /// User can use the app (not suspended and email verified).
  bool get isActive => !isSuspended && emailVerified;

  /// User should be prompted to verify email.
  bool get needsEmailVerification => !emailVerified;

  /// User account is suspended.
  bool get isSuspendedAccount => isSuspended;
}
