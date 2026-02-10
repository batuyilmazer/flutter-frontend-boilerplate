import 'package:flutter/material.dart';
import '../atoms/app_button.dart';
import '../molecules/labeled_text_field.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// Form state for auth screens (login/register).
class AuthFormState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;

  const AuthFormState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isLoading = false,
  });

  AuthFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isLoading,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Reusable authentication form component.
///
/// Provides email and password inputs with validation. Can be used
/// for both login and register screens.
class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
    this.submitLabel = 'Submit',
    this.emailLabel = 'Email',
    this.passwordLabel = 'Password',
    this.emailHint,
    this.passwordHint,
    this.isLoading = false,
    this.emailError,
    this.passwordError,
  });

  final void Function(String email, String password) onSubmit;
  final String submitLabel;
  final String emailLabel;
  final String passwordLabel;
  final String? emailHint;
  final String? passwordHint;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_emailController.text.trim(), _passwordController.text);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return widget.emailError;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return widget.passwordError;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledTextField(
            label: widget.emailLabel,
            controller: _emailController,
            hint: widget.emailHint ?? 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
            errorText: widget.emailError,
            isRequired: true,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          SizedBox(height: spacing.s16),
          LabeledTextField(
            label: widget.passwordLabel,
            controller: _passwordController,
            hint: widget.passwordHint ?? 'Enter your password',
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            errorText: widget.passwordError,
            isRequired: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
          SizedBox(height: spacing.s24),
          AppButton(
            label: widget.submitLabel,
            onPressed: widget.isLoading ? null : _handleSubmit,
            isLoading: widget.isLoading,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
