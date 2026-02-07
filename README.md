# Flutter Frontend Boilerplate

A production-ready Flutter application boilerplate with clean architecture, authentication, and modern UI components.

## Getting Started

This project is a starting point for a Flutter application with:

- **Clean Architecture**: Feature-based folder structure with separation of concerns
- **Authentication**: Complete auth flow with JWT tokens, refresh tokens, and session management
- **State Management**: Provider pattern with ChangeNotifier (AuthNotifier, ThemeNotifier)
- **Routing**: GoRouter with auth guards; optional shell layout (bottom nav) — see [docs/Routing.md](docs/Routing.md)
- **Theme**: Design tokens, light/dark mode, ThemeNotifier — see [docs/ThemeProvider.md](docs/ThemeProvider.md)
- **UI Components**: Atomic design (atoms, molecules, organisms) and reusable layout (e.g. MainShell)
- **Network Layer**: HTTP client with automatic token injection and refresh
- **Secure Storage**: Encrypted storage for sensitive data

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK 3.9+
- Backend API (default: `http://localhost:3000`)

### Installation

1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set the API base URL in `lib/core/config/app_config.dart` if needed.
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure: `lib/`

```
lib/
├── main.dart                    # Entry point; Provider, router, theme
├── core/                        # Shared infrastructure
│   ├── config/                  # App config (e.g. API base URL)
│   ├── errors/                  # AppException, ApiException, AuthException
│   ├── models/                  # User, Session (Freezed)
│   ├── network/                 # ApiClient, AuthInterceptor
│   └── storage/                 # SecureStorage (tokens, user)
├── features/                    # Feature modules
│   ├── auth/                    # Login, register, AuthNotifier, AuthRepository
│   └── profile/                 # Home screen (protected)
├── routing/                     # GoRouter setup and route definitions
│   ├── app_router.dart          # createRouter, RoutingMode (plain / shell)
│   ├── route_paths.dart         # Central path constants (AppRoutes)
│   ├── guards/                  # AuthGuard (redirect logic)
│   └── builders/                # AuthRoutes, ProfileRoutes, ShellRoutes
├── theme/                       # Theme data, notifier, design tokens
│   ├── theme_data.dart          # AppThemeData (Freezed), light/dark
│   ├── theme_notifier.dart      # Theme mode state (Provider)
│   ├── theme_builder.dart       # AppThemeData → ThemeData
│   └── *_schemes/               # Color, typography, spacing, radius
└── ui/                          # Reusable UI
    ├── atoms/                   # AppText, AppButton, AppTextField, AppIcon
    ├── molecules/               # LabeledTextField
    ├── organisms/               # AuthForm
    └── layout/                  # MainShell (shell routing layout)
```

---

## Core (`lib/core/`)

Shared infrastructure used by features.

- **config**: `AppConfig.apiBaseUrl` for the backend.
- **errors**: `AppException`, `ApiException`, `AuthException` for consistent error handling.
- **models**: `User`, `Session` (Freezed + JSON).
- **network**: `ApiClient` (getJson/postJson), `AuthInterceptor` (token injection, 401 refresh).
- **storage**: `SecureStorage` / `SecureStorageImpl` (flutter_secure_storage) for tokens and user.

---

## Features (`lib/features/`)

### Auth (`features/auth/`)

- **data**: `AuthApi` (login, register, refresh, logout, getMe, …), `AuthRepository` (session restore, token persistence).
- **presentation**: `AuthNotifier` (ChangeNotifier), `AuthState` (sealed), `LoginScreen`, `RegisterScreen`; uses `AuthForm` organism.

### Profile (`features/profile/`)

- **presentation**: `HomeScreen` (protected post-login screen).

---

## Routing (`lib/routing/`)

GoRouter is configured in `AppRouter.createRouter(context, { RoutingMode mode = RoutingMode.plain })`. Auth routes (login, register) are always present; authenticated area uses either **plain** feature routes (`ProfileRoutes`) or **shell** routes (`ShellRoutes` with `MainShell` and optional bottom nav).

- **Paths**: All paths are in `route_paths.dart` (`AppRoutes`).
- **Guard**: `AuthGuard` redirects unauthenticated users to login and authenticated users away from auth pages.
- **Builders**: `AuthRoutes`, `ProfileRoutes`, `ShellRoutes` (used when `mode == RoutingMode.shell`).

**Detaylı mimari, yeni route/shell ekleme ve mod seçimi için [docs/Routing.md](docs/Routing.md) dosyasına bakın.**

---

## Theme (`lib/theme/`)

Tema, `AppThemeData` (Freezed) ve `ThemeNotifier` (Provider) ile yönetilir. `ThemeBuilder` ile `ThemeData` üretilir; renk, tipografi, spacing ve radius için scheme’ler kullanılır. Light/dark mod `ThemeNotifier.themeMode` ile değiştirilir.

**Tema yapısı, kullanım ve genişletme için [docs/ThemeProvider.md](docs/ThemeProvider.md) dosyasına bakın.**

---

## UI Components (`lib/ui/`)

- **atoms**: `AppText`, `AppTextField`, `AppButton`, `AppIcon`.
- **molecules**: `LabeledTextField`.
- **organisms**: `AuthForm` (email/password, validation, loading).
- **layout**: `MainShell` — shell layout (Scaffold + bottom nav); tab config via `ShellTabConfig`. Kullanımı [docs/Routing.md](docs/Routing.md) içinde anlatılır.

---

## Main Entry Point (`main.dart`)

- `MultiProvider`: `AuthNotifier`, `ThemeNotifier`.
- `Consumer<ThemeNotifier>`: theme mode’a göre `MaterialApp.router` theme/darkTheme.
- Router: `AppRouter.createRouter(context)` (varsayılan plain mod; shell için `mode: RoutingMode.shell`).
- Theme: `AppThemeData.light().toThemeData()` / `AppThemeData.dark().toThemeData()`.

---

## Data Flow

### Authentication

1. UI → `AuthNotifier.login()` → `AuthRepository` → `AuthApi` + `SecureStorage`.
2. `ApiClient` + `AuthInterceptor`: istekte token eklenir; 401’de refresh denenir ve istek tekrarlanır.
3. Sonuç → repository → notifier → UI güncellenir.

### Auto-login

- Uygulama açılışında `AuthNotifier._initialize()` → `AuthRepository.restoreSession()` → storage’dan token/user; gerekirse `/me` veya refresh.

---

## Customization

- **Yeni feature**: `lib/features/<feature>/` (data + presentation); route’ları [docs/Routing.md](docs/Routing.md) içindeki “Yeni Feature Ekleme” adımlarına göre ekleyin.
- **Tema**: Renk, tipografi, spacing değişiklikleri için [docs/ThemeProvider.md](docs/ThemeProvider.md) ve `lib/theme/` içindeki scheme’lere bakın.
- **API**: `AuthApi` veya yeni API sınıfları; `ApiClient.getJson` / `postJson`; gerekirse repository ve notifier ekleyin.

---

## Documentation

| Konu | Dosya |
|------|--------|
| Routing (modüler yapı, guards, shell, yeni route/feature) | [docs/Routing.md](docs/Routing.md) |
| Tema (ThemeNotifier, AppThemeData, token’lar, genişletme) | [docs/ThemeProvider.md](docs/ThemeProvider.md) |

---

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GoRouter](https://pub.dev/packages/go_router)
- [Provider](https://pub.dev/packages/provider)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## Notes

- API base URL: `lib/core/config/app_config.dart`.
- Tokens: `flutter_secure_storage`; 401’de otomatik refresh.
- Route path’leri yalnızca `AppRoutes` sabitleriyle kullanın; ayrıntılar [docs/Routing.md](docs/Routing.md).
- Tema ve routing için detaylı açıklamalar `docs/` altındaki ilgili dosyalarda yer alır.
