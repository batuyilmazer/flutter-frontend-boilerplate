/// Base application-level exception.
abstract class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Generic network/API exception with optional HTTP status code.
class ApiException extends AppException {
  ApiException({required String message, this.statusCode}) : super(message);

  final int? statusCode;
}

/// Thrown when authentication is required or has failed.
class AuthException extends AppException {
  AuthException(String message) : super(message);
}
