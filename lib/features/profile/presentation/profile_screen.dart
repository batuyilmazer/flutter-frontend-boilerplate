import 'package:flutter/material.dart';
import 'package:flutter_frontend_boilerplate/core/models/user/models.dart';
import 'package:flutter_frontend_boilerplate/features/auth/presentation/auth_providers.dart';
import 'package:flutter_frontend_boilerplate/theme/extensions/theme_context_extensions.dart';
import 'package:flutter_frontend_boilerplate/ui/atoms/app_text.dart';

/// Profile screen showing authenticated user's [User] and [Profile] data.
/// Accessible from the main (home) screen via the Profile button or shell tab.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _hasRequestedRefresh = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasRequestedRefresh) {
      _hasRequestedRefresh = true;
      // Refresh user info from backend when entering the profile tab
      context.authNotifier.refreshUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watchAuthNotifier();
    final user = authNotifier.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const AppText.title('Profile')),
        body: const Center(child: AppText.body('Not signed in.')),
      );
    }

    final spacing = context.appSpacing;

    return Scaffold(
      appBar: AppBar(title: const AppText.title('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.headline('User'),
              SizedBox(height: spacing.s8),
              _Row(label: 'Id', value: user.id),
              _Row(label: 'Email', value: user.email),
              _Row(label: 'Email verified', value: user.emailVerified.toString()),
              _Row(label: 'Suspended', value: user.isSuspended.toString()),
              _Row(
                label: 'Last login',
                value: user.lastLoginAt?.toIso8601String() ?? '—',
              ),
              _Row(
                label: 'Created at',
                value: user.createdAt?.toIso8601String() ?? '—',
              ),
              _Row(
                label: 'Updated at',
                value: user.updatedAt?.toIso8601String() ?? '—',
              ),
              SizedBox(height: spacing.s24),
              AppText.headline('Profile'),
              SizedBox(height: spacing.s8),
              const AppText.body(
                'Profile data will appear here when provided by the backend.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.appSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: AppText.body('$label:'),
          ),
          Expanded(child: AppText.body(value)),
        ],
      ),
    );
  }
}
