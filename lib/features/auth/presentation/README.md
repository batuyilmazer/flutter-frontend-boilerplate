# Auth State Management

This directory contains the authentication state management layer using Provider.

## Files

- **`auth_state.dart`**: Defines the authentication state types (AuthenticatedState, UnauthenticatedState, etc.)
- **`auth_notifier.dart`**: ChangeNotifier that manages auth state and provides methods for login, register, logout
- **`auth_providers.dart`**: Provider widget and extension methods for easy access

## Usage

### 1. Setup Provider in main.dart

```dart
import 'package:provider/provider.dart';
import 'features/auth/presentation/auth_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthNotifier(),
      child: MyApp(),
    ),
  );
}
```

### 2. Access Auth State in Widgets

```dart
// Watch auth state (rebuilds when state changes)
final authNotifier = context.watchAuthNotifier();
final state = authNotifier.state;

if (state is AuthenticatedState) {
  final user = state.user;
  // Show authenticated UI
} else if (state is UnauthenticatedState) {
  // Show login screen
} else if (state is AuthLoadingState) {
  // Show loading indicator
} else if (state is AuthErrorState) {
  // Show error message: state.message
}

// Or use convenience getters
if (authNotifier.isAuthenticated) {
  final user = authNotifier.currentUser;
}
```

### 3. Perform Auth Actions

```dart
final authNotifier = context.authNotifier; // Don't listen to changes

// Login
await authNotifier.login(
  email: 'user@example.com',
  password: 'password123',
);

// Register
await authNotifier.register(
  email: 'user@example.com',
  password: 'password123',
);

// Logout
await authNotifier.logout();

// Logout from all devices
await authNotifier.logoutAll();
```

### 4. Listen to Auth State Changes

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        final state = authNotifier.state;
        
        if (state is AuthenticatedState) {
          return HomeScreen(user: state.user);
        } else if (state is UnauthenticatedState) {
          return LoginScreen();
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
```

