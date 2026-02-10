[EN](../en/ErrorHandling.md) | TR

# Error Handling (Exception → Failure → Result)

Bu projede hatalar, domain/presentation katmanlarında **data olarak** taşınır. Düşük seviyede (network/storage) exception kullanılabilir; ancak UI’ya exception fırlatmak yerine typed `Failure` ile `Result<T>` döndürmek esastır.

İlgili dokümanlar:
- Network layer mapping noktaları: [`Network.md`](Network.md)
- Auth flow (auth failure’ları): [`Auth.md`](Auth.md)

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

Barrel import önerisi:

```dart
import 'package:flutter_frontend_boilerplate/core/errors/errors.dart';
```

---

## Key concepts

### Exceptions (low-level)

Infrastructure tarafında exception fırlatılabilir:
- `ApiException` (HTTP/network)
- `AuthException` (auth)

Repository katmanında bunlar `ErrorMapper` ile typed `Failure`’a çevrilir.

### Failures (domain-level)

Domain/presentation katmanında typed failure’lar kullanılır:
- `ConnectionFailure`, `TimeoutFailure`, `ServerFailure`, `ClientFailure`
- `InvalidCredentialsFailure`, `SessionExpiredFailure`, vb.
- `ValidationFailure` (field-level)

### Result<T>

Repository çıktısı:
- success: `(data: T, failure: null)`
- failure: `(data: null, failure: Failure)`

---

## Usage

### Repository pattern

Repository’de exception yakala + `Result<T>` döndür:

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

### UI: field-level errors

Backend 422 ile field error döndüğünde, `ValidationFailure.fieldErrors` üzerinden form alanlarının hata mesajlarını bağlayın.

---

## Developer guide

### Yeni Failure tipi ekleme

1. `<feature>_failure.dart` ekleyin (veya mevcut gruba genişletin)
2. `ErrorMapper` içine mapping kuralları ekleyin (status code, error code, exception type)
3. Notifier’da failure tipine göre UI davranışını belirleyin (pattern matching)

### Backend field validation desteği

Backend 422 payload’ı structured ise:
1. `ErrorMapper.mapApiException` içinde parse edin
2. `ValidationFailure.fieldErrors` doldurun
3. Form UI’da input’lara bağlayın

---

## Troubleshooting

- **Exception UI’ya kadar geliyor**: repository katmanında catch+map olduğundan emin olun.
- **Sık “unknown error”**: `ErrorMapper.mapException` branch’lerini genişletin.
- **UI mesajları dağınık**: notifier seviyesinde mesaj/aksiyon kararını merkezi hale getirin.

---

## References

- Exceptions: `lib/core/errors/app_exception.dart`
- Failures: `lib/core/errors/*_failure.dart`
- Result: `lib/core/errors/result.dart`
- Mapper: `lib/core/errors/error_mapper.dart`
- Global handler: `lib/core/errors/global_error_handler.dart`

