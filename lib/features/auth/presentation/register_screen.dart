import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../ui/atoms/app_text.dart';
import '../../../ui/organisms/auth_form.dart';
import '../../../theme/extensions/theme_context_extensions.dart';
import '../../../core/errors/validation_failure.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';
import '../../../routing/route_paths.dart';

/// Register screen for new user signup.
///
/// Uses [AuthForm] component and [AuthNotifier] for state management.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: const AppText.title('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthNotifier>(
          builder: (context, authNotifier, child) {
            final state = authNotifier.state;

            // Handle error state
            if (state is AuthErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showErrorSnackBar(context, state.message);
                authNotifier.clearError();
              });
            }

            // Navigate on successful registration
            if (state is AuthenticatedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Navigation will be handled by routing layer
                // For now, just clear errors
                _emailError = null;
                _passwordError = null;
              });
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: spacing.s16),
                  AppText.bodySmall(
                    'Create a new account to get started',
                    textAlign: TextAlign.center,
                    color: colors.textSecondary,
                  ),
                  SizedBox(height: spacing.s32),
                  // Register form
                  AuthForm(
                    onSubmit: (email, password) async {
                      _emailError = null;
                      _passwordError = null;
                      await authNotifier.register(
                        email: email,
                        password: password,
                      );

                      // Check for field-level validation errors if present.
                      final state = authNotifier.state;
                      if (state is AuthErrorState && state.failure is ValidationFailure) {
                        final failure = state.failure as ValidationFailure;
                        _applyFieldErrors(failure);
                      } else if (state is AuthErrorState) {
                        // Fallback to simple parsing for non-validation failures.
                        _parseError(state.message);
                      }
                    },
                    submitLabel: 'Sign Up',
                    emailLabel: 'Email',
                    passwordLabel: 'Password',
                    emailHint: 'Enter your email address',
                    passwordHint: 'Create a password (min. 6 characters)',
                    isLoading: state is AuthLoadingState,
                    emailError: _emailError,
                    passwordError: _passwordError,
                  ),
                  SizedBox(height: spacing.s24),
                  // Terms and conditions
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.s16,
                    ),
                    child: AppText.caption(
                      'By signing up, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: spacing.s24),
                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.bodySmall(
                        'Already have an account? ',
                        color: colors.textSecondary,
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                        child: AppText.bodySmall(
                          'Sign In',
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _parseError(String message) {
    // Simple error parsing - can be enhanced based on backend error format
    if (message.toLowerCase().contains('email')) {
      _emailError = message;
    } else if (message.toLowerCase().contains('password')) {
      _passwordError = message;
    }
    setState(() {});
  }

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

  void _showErrorSnackBar(BuildContext context, String message) {
    final colors = context.appColors;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.bodySmall(message),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

