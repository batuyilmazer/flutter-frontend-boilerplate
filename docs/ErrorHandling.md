## Error & Exception Handling

Bu proje, hataları iki seviyede ele alır:

- **Exception seviyesi**: Network ve auth gibi düşük seviye bileşenlerde Dart exception’ları (`ApiException`, `AuthException`) kullanılır.
- **Domain seviyesi**: Feature ve UI katmanlarında value-based `Failure` hiyerarşisi ve `Result<T>` tipi kullanılır.

Amaç:

- **Merkezi ve genişletilebilir** bir hata modeli ile repository → notifier → UI akışında exception fırlatmadan hata taşıyabilmek,
- Network / auth / validation / storage hatalarını **tür bazlı** ayırmak,
- UI’da duruma göre farklı davranışlar (snackbar, logout, alan hatası vs.) sergileyebilmek.

---

## Dosya Yapısı

Hata yönetimi ile ilgili tüm core dosyalar:

```text
lib/core/errors/
├── app_exception.dart        // Düşük seviye exception’lar (AppException, ApiException, AuthException)
├── failure.dart              // Base Failure sealed class
├── network_failure.dart      // NetworkFailure ve alt tipleri
├── auth_failure.dart         // AuthFailure ve alt tipleri
├── storage_failure.dart      // StorageFailure ve alt tipleri
├── validation_failure.dart   // ValidationFailure (field errors)
├── result.dart               // Result<T> typedef ve helper’lar
├── error_mapper.dart         // Exception → Failure dönüştürücüsü
├── global_error_handler.dart // Global Flutter/Dart error yakalayıcı
└── errors.dart               // Barrel export (hepsini buradan import et)
```

Genel kullanım için tek bir import yeterlidir:

```dart
import 'package:.../core/errors/errors.dart';
```

---

## Exception Katmanı

`lib/core/errors/app_exception.dart` düşük seviye exception’ları tanımlar:

```dart
/// Base application-level exception.
abstract class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Generic network/API exception with optional HTTP status code.
class ApiException extends AppException {
  ApiException(super.message, {this.statusCode});

  final int? statusCode;
}

/// Thrown when authentication is required or has failed.
class AuthException extends AppException {
  AuthException(super.message);
}
```

**Nerede kullanılıyor?**

- `ApiClient` HTTP hatalarında `ApiException` fırlatır.
- `AuthInterceptor` refresh başarısız olduğunda `ApiException` fırlatır.
- Bazı eski kodlar (ör. `sendTwoFa`, `verifyEmail`, `resetPassword`) `AuthException` fırlatır; bunlar `ErrorMapper` ile `Failure`’a çevrilir.

Bu seviyedeki exception’lar **core/network** gibi düşük seviyelerde kalmalı, üst katmanlara mümkün olduğunca `Failure`/`Result` olarak taşınmalıdır.

---

## Failure Hiyerarşisi

Tüm domain seviyesindeki hatalar `Failure`’dan türetilir.

### Base Failure

`lib/core/errors/failure.dart`:

```dart
sealed class Failure {
  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  final String message;        // UI’da gösterilebilecek mesaj (veya çevrilebilir)
  final String? code;          // Backend error code (örn. "EMAIL_TAKEN")
  final Object? originalError; // Orijinal exception (logging için)

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}
```

Bu sınıf:

- **UI katmanına** hata mesajı ve ek metadata (code) taşımak için kullanılır.
- **Logging ve debugging** için orijinal exception’ı (`originalError`) saklar.

### Network Failures

`lib/core/errors/network_failure.dart`:

```dart
sealed class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
    super.originalError,
  });
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.code,
    super.originalError,
  });
}

class ServerFailure extends NetworkFailure {
  const ServerFailure({
    required this.statusCode,
    super.message = 'Server error occurred. Please try again later.',
    super.code,
    super.originalError,
  });

  final int statusCode;
}

class ClientFailure extends NetworkFailure {
  const ClientFailure({
    required this.statusCode,
    super.message = 'Request failed. Please check your input and try again.',
    super.code,
    super.originalError,
  });

  final int statusCode;
}

class UnknownNetworkFailure extends NetworkFailure {
  const UnknownNetworkFailure({
    super.message = 'An unexpected network error occurred.',
    super.code,
    super.originalError,
  });
}
```

Bu tipler sayesinde:

- UI’da **bağlantı yok**, **timeout**, **server error** gibi durumlar ayrı ayrı ele alınabilir.
- Monitoring tarafında HTTP status kodları üzerinden daha anlamlı loglar üretilir.

### Auth Failures

`lib/core/errors/auth_failure.dart`:

```dart
sealed class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.code,
    super.originalError,
  });
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure({
    super.message = 'Session expired. Please login again.',
    super.code,
    super.originalError,
  });
}

class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure({
    super.message = 'Please verify your email address to continue.',
    super.code,
    super.originalError,
  });
}

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

  /// Ör: { "email": "Already taken" }
  final Map<String, String> fieldErrors;
}
```

Bu sınıflar auth flow’larında (login, register, session) UI’nın **neden hata olduğunu anlamasını** ve doğru mesaj/aksiyonu göstermesini sağlar.

### Storage Failures

`lib/core/errors/storage_failure.dart`:

```dart
sealed class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

class StorageReadFailure extends StorageFailure {
  const StorageReadFailure({
    super.message = 'Failed to read data from storage.',
    super.code,
    super.originalError,
  });
}

class StorageWriteFailure extends StorageFailure {
  const StorageWriteFailure({
    super.message = 'Failed to write data to storage.',
    super.code,
    super.originalError,
  });
}

class StorageClearFailure extends StorageFailure {
  const StorageClearFailure({
    super.message = 'Failed to clear data from storage.',
    super.code,
    super.originalError,
  });
}
```

Şu an bazı storage hataları sessizce yutuluyor; ileride bu tipler üzerinden repo / notifier seviyesinde daha detaylı handling eklenebilir.

### Validation Failure

`lib/core/errors/validation_failure.dart`:

```dart
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
    super.code,
    super.originalError,
  });

  /// Field bazlı validation hataları:
  /// {
  ///   "email": ["Email is invalid", "Email is already taken"],
  ///   "password": ["Password is too short"],
  /// }
  final Map<String, List<String>> fieldErrors;
}
``>

Bu sınıf özellikle form ekranlarında field-level hata gösterimi için kullanılır.

---

## Result<T> Tipi

`lib/core/errors/result.dart`:

Amaç:  
Repository / service katmanında **beklenen hatalar için exception fırlatmak yerine** value-based bir sonuç döndürmek.

```dart
import 'failure.dart';

typedef Result<T> = ({T? data, Failure? failure});

Result<T> success<T>(T data) => (data: data, failure: null);
Result<T> fail<T>(Failure failure) => (data: null, failure: failure);

extension ResultX<T> on Result<T> {
  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  T get requireData {
    final value = data;
    if (value == null) {
      throw StateError('Result does not contain data. Failure: $failure');
    }
    return value;
  }

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
```

**Not:**  
Bu, `Either<Failure, T>` gibi FP kütüphanelerine benzer ama **ekstra bağımlılık gerektirmeyen** basit bir record-based implementasyondur.

---

## ErrorMapper

`lib/core/errors/error_mapper.dart`:

Amaç:  
Düşük seviye exception’ları (`ApiException`, `AuthException`, `SocketException`, `TimeoutException` vb.) **merkezi bir noktada** uygun `Failure` tipine dönüştürmek.

```dart
import 'dart:async';
import 'dart:io';

import 'app_exception.dart';
import 'auth_failure.dart';
import 'failure.dart';
import 'network_failure.dart';
import 'validation_failure.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure mapApiException(ApiException exception) {
    final status = exception.statusCode;

    if (status == null) {
      return UnknownNetworkFailure(
        message: exception.message,
        originalError: exception,
      );
    }

    if (status == 401) {
      return SessionExpiredFailure(
        message: exception.message,
        originalError: exception,
      );
    }

    if (status == 422) {
      // Backend validation formatına göre burada fieldErrors parse edilebilir.
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

  static Failure mapException(Object error) {
    if (error is Failure) return error;
    if (error is ApiException) return mapApiException(error);

    if (error is AuthException) {
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
```

Bu sayede:

- Repository ve Notifier katmanları exception türlerini bilmek zorunda kalmaz.
- Tüm mapping mantığı tek dosyada tutulur, kolayca genişletilebilir.

---

## Repository Katmanı

Örnek: `AuthRepository`

`lib/features/auth/data/auth_repository.dart`:

```dart
import '../../../core/errors/errors.dart';
import '../../../core/models/user/models.dart';
import '../../../core/storage/secure_storage_impl.dart';
import 'auth_api.dart';

class AuthRepository {
  AuthRepository({
    AuthApi? authApi,
    SecureStorageImpl? storage,
  })  : _authApi = authApi ?? AuthApi(),
        _storage = storage ?? SecureStorageImpl();

  final AuthApi _authApi;
  final SecureStorageImpl _storage;

  Future<Result<User>> register({
    required String email,
    required String password,
  }) async {
    return _safeCall(() async {
      final response = await _authApi.register(
        email: email,
        password: password,
      );

      await _saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.session.refreshToken,
        deviceId: response.session.deviceId,
        user: response.user,
      );

      return response.user;
    });
  }

  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    return _safeCall(() async {
      final existingDeviceId = await _storage.getDeviceId();

      final response = await _authApi.login(
        email: email,
        password: password,
        deviceId: existingDeviceId,
      );

      await _saveAuthData(
        accessToken: response.accessToken,
        refreshToken: response.session.refreshToken,
        deviceId: response.session.deviceId,
        user: response.user,
      );

      return response.user;
    });
  }

  Future<Result<T>> _safeCall<T>(Future<T> Function() action) async {
    try {
      final data = await action();
      return success<T>(data);
    } on ApiException catch (e) {
      return fail<T>(ErrorMapper.mapApiException(e));
    } catch (e) {
      return fail<T>(ErrorMapper.mapException(e));
    }
  }
}
```

**Özet:**

- Repository, dışarıya **exception fırlatmak yerine** `Result<T>` döndürür.
- Düşük seviye hatalar `_safeCall` içinde `ErrorMapper` ile `Failure`’a çevrilir.

---

## Presentation Katmanı

### AuthState

`lib/features/auth/presentation/auth_state.dart`:

```dart
import '../../../core/errors/failure.dart';
import '../../../core/models/user/models.dart';

sealed class AuthState {
  const AuthState();
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class AuthenticatedState extends AuthState {
  const AuthenticatedState(this.user);

  final User user;
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthErrorState extends AuthState {
  const AuthErrorState(this.message, {this.failure});

  final String message;
  final Failure? failure;
}
```

`AuthErrorState.failure` ile UI, hata tipine göre farklı davranışlar uygulayabilir.

### AuthNotifier

`lib/features/auth/presentation/auth_notifier.dart`:

```dart
import 'package:flutter/foundation.dart';
import '../../../core/errors/errors.dart';
import '../../../core/models/user/models.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends ChangeNotifier {
  // ...

  Future<void> register({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
      );
      result.when(
        success: (user) {
          _state = AuthenticatedState(user);
          notifyListeners();
        },
        failure: _handleFailure,
      );
    } catch (e) {
      _handleFailure(ErrorMapper.mapException(e));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );
      result.when(
        success: (user) {
          _state = AuthenticatedState(user);
          notifyListeners();
        },
        failure: _handleFailure,
      );
    } catch (e) {
      _handleFailure(ErrorMapper.mapException(e));
    }
  }

  void _handleFailure(Failure failure) {
    final message = switch (failure) {
      SessionExpiredFailure _ =>
        'Session expired. Please login again.',
      InvalidCredentialsFailure _ => failure.message,
      ConnectionFailure _ =>
        'No internet connection. Please check your network.',
      TimeoutFailure _ =>
        'Request timed out. Please try again.',
      _ => failure.message,
    };
    _state = AuthErrorState(message, failure: failure);
    notifyListeners();
  }
}
```

**Önemli noktalar:**

- `Result<T>.when` ile success/failure ayrımı tek noktadan yapılır.
- Hata mesajları `Failure` tipine göre özelleştirilir.

---

## UI: Field-Level Hata Gösterimi

Login ve Register ekranlarında, `ValidationFailure` üzerinden field-level hata set edilir.

Örnek: `lib/features/auth/presentation/login_screen.dart`:

```dart
AuthForm(
  onSubmit: (email, password) async {
    _emailError = null;
    _passwordError = null;
    await authNotifier.login(
      email: email,
      password: password,
    );

    final state = authNotifier.state;
    if (state is AuthErrorState && state.failure is ValidationFailure) {
      final failure = state.failure as ValidationFailure;
      _applyFieldErrors(failure);
    } else if (state is AuthErrorState) {
      // Backend henüz fieldErrors döndürmüyorsa eski string parsing devam eder.
      _parseError(state.message);
    }
  },
  // ...
);
```

```dart
void _applyFieldErrors(ValidationFailure failure) {
  final emailErrors = failure.fieldErrors['email'];
  final passwordErrors = failure.fieldErrors['password'];

  _emailError = (emailErrors != null && emailErrors.isNotEmpty)
      ? emailErrors.first
      : null;
  _passwordError = (passwordErrors != null && passwordErrors.isNotEmpty)
      ? passwordErrors.first
      : null;

  setState(() {});
}
```

Bu yapı, backend tarafında field-level validation döndüğünüz anda otomatik olarak daha zengin hata gösterimine izin verir.

---

## Global Error Handler

`lib/core/errors/global_error_handler.dart` ve `lib/main.dart`:

```dart
// global_error_handler.dart
import 'dart:ui';
import 'package:flutter/foundation.dart';

class GlobalErrorHandler {
  const GlobalErrorHandler._();

  static void init() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      _report(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _report(error, stack);
      return true;
    };
  }

  static void _report(Object error, StackTrace? stack) {
    if (kDebugMode) {
      debugPrint('Uncaught error: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }
}
```

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/errors/global_error_handler.dart';
import 'features/auth/presentation/auth_notifier.dart';
import 'routing/app_router.dart';
import 'theme/theme_notifier.dart';
import 'theme/theme_data.dart';
import 'theme/extensions/theme_data_extensions.dart';

void main() {
  GlobalErrorHandler.init();
  runApp(const MyApp());
}
```

Bu handler:

- Flutter framework hatalarını,
- Yakalanmamış async hataları

toplayıp debug modda loglar; production’da Crashlytics/Sentry entegrasyonu için merkezi bir entry point sağlar.

---

## Yeni Feature’lar İçin Genişletme Rehberi

Yeni bir feature (örn. `payment`) eklerken aşağıdaki adımları izleyin:

1. **Failure türlerini tanımla**  
   `lib/core/errors/payment_failure.dart`:

   ```dart
   sealed class PaymentFailure extends Failure { ... }
   class PaymentDeclinedFailure extends PaymentFailure { ... }
   class CardExpiredFailure extends PaymentFailure { ... }
   ```

2. **ErrorMapper’a ekle**  
   `error_mapper.dart` içinde backend’in payment error code’larına göre `PaymentFailure` case’leri ekleyin.

3. **Repository’de Result<T> kullan**  

   ```dart
   Future<Result<PaymentResult>> pay(...) => _safeCall(() async { ... });
   ```

4. **Notifier’da pattern matching**  

   ```dart
   void _handleFailure(Failure failure) {
     switch (failure) {
       case PaymentDeclinedFailure():
         // özel mesaj + UI davranışı
       case ConnectionFailure():
         // network mesajı
       default:
         // genel mesaj
     }
   }
   ```

5. **UI’da fieldErrors ve Failure tipine göre davran**  

- `ValidationFailure.fieldErrors` ile form alanlarını doldur.
- Belirli `Failure` tiplerine özel snackbar/redirect davranışları ekle.

Bu pattern ile error handling:

- **Merkezi** (`ErrorMapper`, `GlobalErrorHandler`),
- **Tip güvenli** (`Failure` sealed class’ları),
- **Genişletilebilir** (feature bazlı yeni Failure tipleri),
- **UI dostu** (`Result<T>` ve `ValidationFailure.fieldErrors`)

hale gelir.

