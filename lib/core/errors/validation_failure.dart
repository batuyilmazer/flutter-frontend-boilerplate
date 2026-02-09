import 'failure.dart';

/// Validation failure for user input or domain invariants.
///
/// Can carry field-specific error messages to allow the UI to highlight
/// problematic fields directly.
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
    super.code,
    super.originalError,
  });

  /// Field-specific error messages, e.g.
  /// {
  ///   "email": ["Email is invalid", "Email is already taken"],
  ///   "password": ["Password is too short"],
  /// }
  final Map<String, List<String>> fieldErrors;
}

