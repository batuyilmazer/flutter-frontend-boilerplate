import 'package:flutter/material.dart';
import '../../../ui/atoms/app_button.dart';
import '../../../ui/atoms/app_text.dart';
import '../../../theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';

/// Home screen shown after successful authentication.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watchAuthNotifier();
    final user = authNotifier.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const AppText.title('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authNotifier.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.headline('Welcome!'),
              const SizedBox(height: AppSpacing.s8),
              if (user != null)
                AppText.body('Email: ${user.email}'),
              const SizedBox(height: AppSpacing.s32),
              AppButton(
                label: 'Logout',
                onPressed: () async {
                  await authNotifier.logout();
                },
                variant: AppButtonVariant.outline,
                isFullWidth: true,
              ),
              const SizedBox(height: AppSpacing.s16),
              AppButton(
                label: 'Logout All Devices',
                onPressed: () async {
                  await authNotifier.logoutAll();
                },
                variant: AppButtonVariant.secondary,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

