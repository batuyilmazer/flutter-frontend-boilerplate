/// Base class for all domain-level failures in the app.
///
/// This is a value-based representation of an error that can be safely passed
/// between layers (repository → notifier → UI) without throwing exceptions.
sealed class Failure {
  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  /// Human-readable message that can be shown to the user (or transformed
  /// into a localized string by the presentation layer).
  final String message;

  /// Optional machine-readable error code, typically coming from the backend
  /// (e.g. "EMAIL_TAKEN", "INVALID_CREDENTIALS").
  final String? code;

  /// The original low-level error/exception for logging and debugging.
  final Object? originalError;

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

