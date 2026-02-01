# Flutter Frontend Boilerplate

A production-ready Flutter application boilerplate with clean architecture, authentication, and modern UI components.

## Getting Started

This project is a starting point for a Flutter application with:

- **Clean Architecture**: Feature-based folder structure with separation of concerns
- **Authentication**: Complete auth flow with JWT tokens, refresh tokens, and session management
- **State Management**: Provider pattern with ChangeNotifier
- **Routing**: GoRouter with authentication guards
- **UI Components**: Atomic design pattern with reusable components
- **Network Layer**: HTTP client with automatic token injection and refresh
- **Secure Storage**: Encrypted storage for sensitive data

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Backend API running (default: `http://localhost:3000`)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Update API base URL in `lib/core/config/app_config.dart` if needed
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure: `/lib/` Directory

The `/lib/` directory follows a clean architecture pattern with feature-based organization. Here's a detailed breakdown:

```
lib/
├── main.dart                 # Application entry point
├── core/                    # Core functionality shared across features
├── features/                 # Feature modules (auth, profile, etc.)
├── routing/                  # Navigation and routing configuration
├── theme/                    # App-wide theme and design tokens
└── ui/                       # Reusable UI components (atomic design)
```

---

## 📁 Core (`/lib/core/`)

Core functionality that is shared across all features. This layer contains infrastructure code that doesn't depend on business logic.

### Configuration (`core/config/`)

**`app_config.dart`**
- Central configuration for the application
- Contains API base URL (`http://localhost:3000` by default)
- Can be extended with environment-specific configurations (dev, staging, prod)
- **Usage**: Use `AppConfig.apiBaseUrl` for all API calls

### Errors (`core/errors/`)

**`app_exception.dart`**
- Base exception class hierarchy for the application
- **`AppException`**: Abstract base class for all app exceptions
- **`ApiException`**: Network/API errors with optional HTTP status code
- **`AuthException`**: Authentication-related errors
- **Usage**: Throw these exceptions in repositories and handle them in UI

### Models (`core/models/`)

**`user.dart`**
- User domain model
- Properties: `id`, `email`
- JSON serialization support (`fromJson`, `toJson`)
- Handles both `id` and `userId` field names from API responses

**`session.dart`**
- Session model for refresh token management
- Properties: `refreshToken`, `deviceId`, `expiresAt`
- Used for multi-device session management

### Network (`core/network/`)

**`api_client.dart`**
- HTTP client wrapper around `package:http`
- Provides `getJson()` and `postJson()` methods
- Automatic JSON encoding/decoding
- Error handling with `ApiException`
- Supports optional `AuthInterceptor` for token management
- Handles 401 responses with automatic token refresh retry

**`auth_interceptor.dart`**
- Interceptor for automatic token injection and refresh
- **Request Interception**: Automatically adds `Authorization: Bearer <token>` header
- **Response Interception**: Handles 401 errors by attempting token refresh
- Retries original request with new token if refresh succeeds
- **Usage**: Pass to `ApiClient` constructor for automatic auth handling

### Storage (`core/storage/`)

**`secure_storage.dart`**
- Abstract interface for secure storage operations
- Methods: `write()`, `read()`, `delete()`
- Defines `SecureStorageKeys` for auth data keys:
  - `accessToken`, `refreshToken`, `deviceId`, `user`

**`secure_storage_impl.dart`**
- Concrete implementation using `flutter_secure_storage`
- Platform-specific secure storage (Keychain on iOS, KeyStore on Android)
- Convenience methods for auth data:
  - `saveAccessToken()`, `getAccessToken()`
  - `saveRefreshToken()`, `getRefreshToken()`
  - `saveDeviceId()`, `getDeviceId()`
  - `saveUser()`, `getUser()`
  - `clearAuthData()`, `hasAuthData()`

---

## 🎯 Features (`/lib/features/`)

Feature modules organized by domain. Each feature follows a layered architecture:

```
feature_name/
├── data/           # Data layer (API clients, repositories)
└── presentation/   # Presentation layer (screens, state management)
```

### Authentication Feature (`features/auth/`)

Complete authentication system with login, registration, and session management.

#### Data Layer (`features/auth/data/`)

**`auth_api.dart`**
- Low-level API client for authentication endpoints
- Methods:
  - `register()` - POST `/auth/register`
  - `login()` - POST `/auth/login`
  - `refresh()` - POST `/auth/refresh`
  - `logout()` - POST `/auth/logout`
  - `logoutAll()` - POST `/auth/logout-all`
  - `getMe()` - GET `/me`
  - `sendTwoFa()` - POST `/auth/2fa`
  - `verifyEmail()` - POST `/auth/verify-email`
  - `resetPassword()` - POST `/auth/reset-password`
- Returns typed response models (`AuthResponse`, `RefreshResponse`)

**`auth_repository.dart`**
- High-level repository for authentication operations
- Orchestrates `AuthApi` calls and `SecureStorage` operations
- Handles token persistence, auto-login, and session management
- Methods:
  - `register()` - Register new user and save tokens
  - `login()` - Login and save tokens
  - `refreshAccessToken()` - Refresh expired access token
  - `logout()` - Logout current session
  - `logoutAll()` - Logout from all devices
  - `getCurrentUser()` - Get user from storage
  - `restoreSession()` - Restore session from storage (auto-login)
  - `sendTwoFa()`, `verifyEmail()`, `resetPassword()` - 2FA operations

#### Presentation Layer (`features/auth/presentation/`)

**`auth_state.dart`**
- Sealed class hierarchy for authentication state
- States:
  - `UnauthenticatedState` - User is logged out
  - `AuthenticatedState(user)` - User is logged in
  - `AuthLoadingState` - Auth operation in progress
  - `AuthErrorState(message)` - Auth operation failed

**`auth_notifier.dart`**
- State management for authentication using `ChangeNotifier`
- Provides reactive auth state to the entire app
- Methods:
  - `register()` - Register new user
  - `login()` - Login with credentials
  - `logout()` - Logout current session
  - `logoutAll()` - Logout from all devices
  - `refreshUser()` - Refresh user info from backend
  - `clearError()` - Clear error state
- Properties:
  - `state` - Current auth state
  - `currentUser` - Current user if authenticated
  - `isAuthenticated` - Boolean auth status
  - `isLoading` - Loading status

**`auth_providers.dart`**
- Provider definitions for dependency injection (if using Riverpod/Provider)

**`login_screen.dart`**
- Login screen UI
- Uses `AuthForm` component
- Connects to `AuthNotifier` for login logic

**`register_screen.dart`**
- Registration screen UI
- Uses `AuthForm` component
- Connects to `AuthNotifier` for registration logic

### Profile Feature (`features/profile/`)

**`presentation/home_screen.dart`**
- Home screen for authenticated users
- Example protected route

---

## 🧭 Routing (`/lib/routing/`)

**`app_router.dart`**
- GoRouter configuration with authentication guards
- **Route Definitions**:
  - `/login` - Login screen
  - `/register` - Registration screen
  - `/` (home) - Home screen (protected)
- **Authentication Guards**:
  - Unauthenticated users → redirected to `/login`
  - Authenticated users → redirected to `/` when accessing auth routes
  - Loading state → no redirect (waits for auth check)
- **Usage**: Call `AppRouter.createRouter(context)` in `main.dart`

---

## 🎨 Theme (`/lib/theme/`)

**`app_theme.dart`**
- Central theme configuration
- **`AppTheme`**: Main theme class with `light` theme
- **`AppColors`**: Color tokens:
  - `primary`, `background`, `textPrimary`, `textSecondary`
  - `error`, `success`, `surface`
- **`AppRadius`**: Border radius tokens (`small`, `medium`, `large`)
- **`AppSpacing`**: Spacing tokens (`s4`, `s8`, `s12`, `s16`, `s24`, `s32`)
- **`AppTypography`**: Text style tokens:
  - `headline`, `title`, `body`, `bodySmall`, `button`, `caption`
- **Usage**: Access via `Theme.of(context)` or directly import tokens

---

## 🧩 UI Components (`/lib/ui/`)

UI components organized using atomic design principles.

### Atoms (`ui/atoms/`)

Smallest reusable components.

**`app_text.dart`**
- Text component with typography variants
- Constructors: `AppText.headline()`, `AppText.title()`, `AppText.body()`, etc.
- Supports custom color, maxLines, textAlign, overflow

**`app_text_field.dart`**
- Text input field with consistent styling
- Supports validation, icons, different input types
- Uses theme tokens for colors and spacing

**`app_button.dart`**
- Button component with variants:
  - `primary` - Main action button
  - `secondary` - Secondary action
  - `outline` - Outlined button
  - `text` - Text button
- Supports loading state, icons, full-width option

**`app_icon.dart`**
- Icon component with size variants (`small`, `medium`, `large`, `xlarge`)
- Consistent sizing and coloring

### Molecules (`ui/molecules/`)

Combinations of atoms.

**`labeled_text_field.dart`**
- Text field with label above it
- Useful for forms with explicit labels
- Supports all `AppTextField` features plus label and required indicator

### Organisms (`ui/organisms/`)

Complex components combining molecules and atoms.

**`auth_form.dart`**
- Complete authentication form
- Includes email and password fields with validation
- Password visibility toggle
- Loading state support
- Customizable labels and hints
- **Usage**: Used in `LoginScreen` and `RegisterScreen`

---

## 📱 Main Entry Point (`main.dart`)

**Application Setup**:
1. Creates `AuthNotifier` with Provider
2. Configures `AppRouter` with auth guards
3. Applies `AppTheme.light` theme
4. Uses `MaterialApp.router` for navigation

**Key Dependencies**:
- `provider` - State management
- `go_router` - Navigation
- `flutter_secure_storage` - Secure storage
- `http` - HTTP client

---

## 🔄 Data Flow

### Authentication Flow

1. **User Action** (e.g., login) → `LoginScreen`
2. **UI** → Calls `AuthNotifier.login()`
3. **State Management** → `AuthNotifier` calls `AuthRepository.login()`
4. **Repository** → Calls `AuthApi.login()` and saves tokens via `SecureStorage`
5. **API** → Makes HTTP request via `ApiClient`
6. **Interceptor** → Adds `Authorization` header automatically
7. **Response** → Returns to repository, saves tokens, returns user
8. **State Update** → `AuthNotifier` updates state, UI rebuilds

### Auto-Login Flow

1. **App Start** → `AuthNotifier._initialize()`
2. **Repository** → `AuthRepository.restoreSession()`
3. **Storage** → Reads tokens from `SecureStorage`
4. **Validation** → Calls `/me` endpoint to validate token
5. **Refresh** → If token expired, attempts refresh
6. **State** → Updates `AuthNotifier` state based on result

### Token Refresh Flow

1. **401 Response** → `ApiClient` detects 401 error
2. **Interceptor** → `AuthInterceptor.interceptResponse()` called
3. **Refresh** → `AuthRepository.refreshAccessToken()` called
4. **Retry** → Original request retried with new token
5. **Success** → Response returned to caller

---

## 🛠️ Customization Guide

### Adding a New Feature

1. Create feature folder: `lib/features/your_feature/`
2. Add data layer: `data/your_feature_api.dart`, `data/your_feature_repository.dart`
3. Add presentation layer: `presentation/your_feature_screen.dart`, `presentation/your_feature_notifier.dart`
4. Add route in `app_router.dart`
5. Use UI components from `lib/ui/` or create new ones

### Customizing Theme

Edit `lib/theme/app_theme.dart`:
- Update `AppColors` for brand colors
- Adjust `AppTypography` for font styles
- Modify `AppRadius` and `AppSpacing` for spacing/radius values

### Adding API Endpoints

1. Add method to appropriate API class (e.g., `AuthApi`)
2. Use `ApiClient.getJson()` or `ApiClient.postJson()`
3. Create response models if needed
4. Add repository method that calls API and handles storage if needed

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 📝 Notes

- The backend API base URL is configured in `lib/core/config/app_config.dart`
- Authentication tokens are stored securely using `flutter_secure_storage`
- The app automatically handles token refresh on 401 errors
- All UI components use theme tokens for consistent styling
- Feature modules are self-contained and can be easily added/removed
