# Error Handling (Exception → Failure → Result)

EN | [TR](../tr/ErrorHandling.tr.md)

This project treats errors as **data** in the domain/presentation layers, while still allowing exceptions in low-level infrastructure code.
The goal is to avoid throwing exceptions through UI code and instead propagate typed failures via `Result<T>`.

Related docs:
- Network layer mapping points: [`Network.md`](Network.md)
- Auth flow (auth-related failures): [`Auth.md`](Auth.md)

---

## Contents

1. [Architecture](#architecture)
2. [File structure](#file-structure)
3. [Key concepts](#key-concepts)
4. [Usage](#usage)
5. [Developer guide](#developer-guide)
6. [Troubleshooting](#troubleshooting)
7. [References](#references)

---

## Architecture

```mermaid
flowchart TB
  UI[UI Widgets] --> Notifier[Notifier]
  Notifier --> Repo[Repository]
  Repo --> ApiClient[ApiClient]

  ApiClient -->|throws| ApiException[ApiException/AuthException/etc.]
  Repo --> ErrorMapper[ErrorMapper]
  ErrorMapper --> Failure[Failure (typed)]
  Repo -->|returns| Result[Result<T>]
  Result --> Notifier --> UI
```

---

## File structure

```text
lib/core/errors/
├── app_exception.dart        # low-level exceptions (ApiException/AuthException)
├── failure.dart              # base Failure type
├── network_failure.dart      # connection/timeout/server/client failures
├── auth_failure.dart         # auth failures
├── storage_failure.dart      # storage failures
├── validation_failure.dart   # field-level errors
├── result.dart               # Result<T> record + helpers
├── error_mapper.dart         # Exception → Failure mapping
├── global_error_handler.dart # uncaught error hook (debug logging)
└── errors.dart               # barrel export
```

Prefer importing the barrel:

```dart
import 'package:flutter_frontend_boilerplate/core/errors/errors.dart';
```

---

## Key concepts

### Exceptions (low-level)

Infrastructure code can throw:
- `ApiException` (HTTP/network semantics)
- `AuthException` (auth-related exceptions)

These should be mapped to domain-level failures in repositories via `ErrorMapper`.

### Failures (domain-level)

Domain/presentation layers work with typed `Failure` objects such as:
- `ConnectionFailure`, `TimeoutFailure`, `ServerFailure`, `ClientFailure`
- `InvalidCredentialsFailure`, `SessionExpiredFailure`, etc.
- `ValidationFailure` for field-level errors

### Result<T>

Repositories return:
- success: `(data: T, failure: null)`
- failure: `(data: null, failure: Failure)`

This keeps error flows explicit and testable.

---

## Usage

### Repository pattern

In repositories, wrap calls and return `Result<T>`:

```dart
Future<Result<T>> _safeCall<T>(Future<T> Function() action) async {
  try {
    final data = await action();
    return success(data);
  } on ApiException catch (e) {
    return fail(ErrorMapper.mapApiException(e));
  } catch (e) {
    return fail(ErrorMapper.mapException(e));
  }
}
```

### UI: show field-level errors

When backend returns field errors, map them into `ValidationFailure.fieldErrors` and render near form fields (see auth screens for usage patterns).

---

## Developer guide

### Add a new Failure type

1. Create `<feature>_failure.dart` (or extend an existing group file)
2. Add mapping rules in `ErrorMapper` (by HTTP status, error code, or exception type)
3. In notifiers, pattern-match on the failure type to choose user-facing behavior/messages

### Add backend field validation support

If your backend returns a structured error payload for status 422:
1. Parse it inside `ErrorMapper.mapApiException`
2. Fill `ValidationFailure.fieldErrors`
3. Update the form UI to bind those errors to inputs

---

## Troubleshooting

- **Unhandled exception reaches UI**: ensure repositories catch and map exceptions to `Failure`.
- **Generic “unknown error” too often**: add more specific branches in `ErrorMapper.mapException`.
- **UI messages inconsistent**: centralize message decisions in notifier-level `_handleFailure` (or a dedicated mapper).

---

## References

- Exceptions: `lib/core/errors/app_exception.dart`
- Failures: `lib/core/errors/*_failure.dart`
- Result: `lib/core/errors/result.dart`
- Mapper: `lib/core/errors/error_mapper.dart`
- Global handler: `lib/core/errors/global_error_handler.dart`

