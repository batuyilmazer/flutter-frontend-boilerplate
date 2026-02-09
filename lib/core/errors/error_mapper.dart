import 'dart:async';
import 'dart:io';

import 'app_exception.dart';
import 'auth_failure.dart';
import 'failure.dart';
import 'network_failure.dart';
import 'validation_failure.dart';

/// Central place to convert low-level exceptions into domain-level [Failure]s.
class ErrorMapper {
  const ErrorMapper._();

  /// Maps an [ApiException] coming from the networking layer to a more specific
  /// [Failure] that can be handled in the domain / presentation layers.
  static Failure mapApiException(ApiException exception) {
    final status = exception.statusCode;

    if (status == null) {
      return UnknownNetworkFailure(
        message: exception.message,
        originalError: exception,
      );
    }

    // Example mapping based purely on HTTP status; this can be extended later
    // to inspect backend-specific error bodies / codes.
    if (status == 401) {
      return SessionExpiredFailure(
        message: exception.message,
        originalError: exception,
      );
    }

    if (status == 422) {
      // Placeholder for future backend validation error parsing.
      return ValidationFailure(
        message: exception.message,
        fieldErrors: const {},
        originalError: exception,
      );
    }

    if (status >= 500 && status < 600) {
      return ServerFailure(
        statusCode: status,
        message: exception.message,
        originalError: exception,
      );
    }

    if (status >= 400 && status < 500) {
      return ClientFailure(
        statusCode: status,
        message: exception.message,
        originalError: exception,
      );
    }

    return UnknownNetworkFailure(
      message: exception.message,
      originalError: exception,
    );
  }

  /// Generic mapping for any [Object] error into a [Failure].
  static Failure mapException(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is ApiException) {
      return mapApiException(error);
    }

    if (error is AuthException) {
      // Keep existing semantics but use Failure hierarchy.
      return InvalidCredentialsFailure(
        message: error.message,
        originalError: error,
      );
    }

    if (error is SocketException) {
      return ConnectionFailure(originalError: error);
    }

    if (error is TimeoutException) {
      return TimeoutFailure(originalError: error);
    }

    return UnknownNetworkFailure(
      message: 'An unexpected error occurred',
      originalError: error,
    );
  }
}

