import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../ui/atoms/app_text.dart';
import '../../../ui/organisms/auth_form.dart';
import '../../../theme/extensions/theme_context_extensions.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';
import '../../../../routing/app_router.dart';

/// Login screen for user authentication.
///
/// Uses [AuthForm] component and [AuthNotifier] for state management.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final colors = context.appColors;

    return Scaffold(
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

            // Navigate on successful login
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
                  SizedBox(height: spacing.s32),
                  // Logo or app name placeholder
                  AppText.headline(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    color: colors.textPrimary,
                  ),
                  SizedBox(height: spacing.s8),
                  AppText.bodySmall(
                    'Sign in to continue',
                    textAlign: TextAlign.center,
                    color: colors.textSecondary,
                  ),
                  SizedBox(height: spacing.s32),
                  SizedBox(height: spacing.s16),
                  // Login form
                  AuthForm(
                    onSubmit: (email, password) async {
                      _emailError = null;
                      _passwordError = null;
                      await authNotifier.login(
                        email: email,
                        password: password,
                      );
                      // Check for errors after login attempt
                      if (authNotifier.state is AuthErrorState) {
                        final errorState = authNotifier.state as AuthErrorState;
                        // Parse error message to set field-specific errors
                        _parseError(errorState.message);
                      }
                    },
                    submitLabel: 'Sign In',
                    emailLabel: 'Email',
                    passwordLabel: 'Password',
                    emailHint: 'Enter your email address',
                    passwordHint: 'Enter your password',
                    isLoading: state is AuthLoadingState,
                    emailError: _emailError,
                    passwordError: _passwordError,
                  ),
                  SizedBox(height: spacing.s24),
                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.bodySmall(
                        "Don't have an account? ",
                        color: colors.textSecondary,
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppRoutes.register);
                        },
                        child: AppText.bodySmall(
                          'Sign Up',
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.s16),
                  // Forgot password link
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password screen
                      _showInfoSnackBar(context, 'Forgot password feature coming soon');
                    },
                    child: AppText.caption(
                      'Forgot Password?',
                      color: colors.textSecondary,
                    ),
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

  void _showInfoSnackBar(BuildContext context, String message) {
    final colors = context.appColors;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.bodySmall(message),
        backgroundColor: colors.textSecondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

