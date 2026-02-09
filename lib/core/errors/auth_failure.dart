import 'failure.dart';

/// Base class for all authentication / authorization related failures.
abstract class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// User provided invalid credentials (e.g. wrong email/password).
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.code,
    super.originalError,
  });
}

/// User session is no longer valid and requires re-authentication.
class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure({
    super.message = 'Session expired. Please login again.',
    super.code,
    super.originalError,
  });
}

/// User needs to verify their email address.
class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure({
    super.message = 'Please verify your email address to continue.',
    super.code,
    super.originalError,
  });
}

/// Two-factor authentication is required to complete the action.
class TwoFactorRequiredFailure extends AuthFailure {
  const TwoFactorRequiredFailure({
    super.message = 'Two-factor authentication is required.',
    super.code,
    super.originalError,
  });
}

/// Generic registration failure with optional field-specific errors.
class RegistrationFailure extends AuthFailure {
  const RegistrationFailure({
    required super.message,
    this.fieldErrors = const {},
    super.code,
    super.originalError,
  });

  /// Optional field-specific error messages, e.g. {"email": "Already taken"}.
  final Map<String, String> fieldErrors;
}

