import 'failure.dart';

/// Base class for all network-related failures.
sealed class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// No internet connection or DNS resolution issues.
class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
    super.originalError,
  });
}

/// Request timed out before the server could respond.
class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.code,
    super.originalError,
  });
}

/// Server responded with a 5xx error.
class ServerFailure extends NetworkFailure {
  const ServerFailure({
    required this.statusCode,
    super.message = 'Server error occurred. Please try again later.',
    super.code,
    super.originalError,
  });

  final int statusCode;
}

/// Client-side HTTP error (typically 4xx responses).
class ClientFailure extends NetworkFailure {
  const ClientFailure({
    required this.statusCode,
    super.message = 'Request failed. Please check your input and try again.',
    super.code,
    super.originalError,
  });

  final int statusCode;
}

/// Fallback for network errors that do not fit other categories.
class UnknownNetworkFailure extends NetworkFailure {
  const UnknownNetworkFailure({
    super.message = 'An unexpected network error occurred.',
    super.code,
    super.originalError,
  });
}

