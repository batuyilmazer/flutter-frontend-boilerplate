import 'failure.dart';

/// Base class for all local storage related failures.
sealed class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Failed to read data from secure storage or local disk.
class StorageReadFailure extends StorageFailure {
  const StorageReadFailure({
    super.message = 'Failed to read data from storage.',
    super.code,
    super.originalError,
  });
}

/// Failed to write data to secure storage or local disk.
class StorageWriteFailure extends StorageFailure {
  const StorageWriteFailure({
    super.message = 'Failed to write data to storage.',
    super.code,
    super.originalError,
  });
}

/// Failed to clear or delete data from storage.
class StorageClearFailure extends StorageFailure {
  const StorageClearFailure({
    super.message = 'Failed to clear data from storage.',
    super.code,
    super.originalError,
  });
}

