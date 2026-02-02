# Test Structure

This directory follows the same structure as `lib/` to maintain consistency and make it easy to locate tests for specific modules.

## Directory Structure

```
test/
├── core/                    # Tests for core functionality
│   ├── models/             # Unit tests for data models
│   ├── errors/             # Tests for exception classes
│   ├── network/            # Tests for network layer (API client, interceptors)
│   └── storage/            # Tests for storage implementations
│
├── features/               # Feature-based tests
│   └── auth/
│       ├── data/          # Unit tests for auth data layer
│       └── presentation/  # Widget and unit tests for auth UI
│
├── ui/                     # UI component tests
│   ├── atoms/             # Tests for atomic components
│   └── molecules/         # Tests for molecular components
│
├── integration_test/       # End-to-end integration tests
│
└── widget_test.dart        # General widget tests
```

## Test Types

### Unit Tests
- Located in: `test/core/`, `test/features/*/data/`
- Test business logic, models, repositories, services
- Example: `test/core/models/user_test.dart`

### Widget Tests
- Located in: `test/ui/`, `test/features/*/presentation/`
- Test UI components and widgets
- Example: `test/ui/atoms/app_button_test.dart`

### Integration Tests
- Located in: `test/integration_test/`
- Test complete user flows and app behavior
- Example: `test/integration_test/app_test.dart`

## Running Tests

### Run all tests
```bash
flutter test
```

### Run unit tests only
```bash
flutter test test/core/ test/features/
```

### Run widget tests only
```bash
flutter test test/ui/ test/widget_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run specific test file
```bash
flutter test test/core/models/user_test.dart
```

## CI/CD

Tests are automatically run in CI/CD pipeline:
- **Unit Tests**: Run in `test-unit` job
- **Widget Tests**: Run in `test-widget` job
- Both jobs run in parallel and generate coverage reports
