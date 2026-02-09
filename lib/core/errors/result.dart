import 'failure.dart';

/// Lightweight result type for operations that can succeed or fail.
///
/// This avoids throwing exceptions for expected failures and instead returns
/// a value-based representation that can be pattern matched in the caller.
typedef Result<T> = ({T? data, Failure? failure});

/// Convenience constructor for a successful result.
Result<T> success<T>(T data) => (data: data, failure: null);

/// Convenience constructor for a failed result.
Result<T> fail<T>(Failure failure) => (data: null, failure: failure);

/// Useful helpers for working with [Result].
extension ResultX<T> on Result<T> {
  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  /// Returns the data if present, otherwise throws [StateError].
  T get requireData {
    final value = data;
    if (value == null) {
      throw StateError('Result does not contain data. Failure: $failure');
    }
    return value;
  }

  /// Exhaustive handling for success and failure cases.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final error = this.failure;
    if (error != null) {
      return failure(error);
    }
    return success(requireData);
  }
}

