import 'package:flutter/material.dart';
import '../../../ui/atoms/app_button.dart';
import '../../../ui/atoms/app_text.dart';
import '../../../theme/extensions/theme_context_extensions.dart';
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
          padding: EdgeInsets.all(context.appSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.headline('Welcome!'),
              SizedBox(height: context.appSpacing.s8),
              if (user != null)
                AppText.body('Email: ${user.email}'),
              SizedBox(height: context.appSpacing.s32),
              AppButton(
                label: 'Logout',
                onPressed: () async {
                  await authNotifier.logout();
                },
                variant: AppButtonVariant.outline,
                isFullWidth: true,
              ),
              SizedBox(height: context.appSpacing.s16),
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

