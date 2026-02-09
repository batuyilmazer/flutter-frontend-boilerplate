import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/errors/global_error_handler.dart';
import 'core/storage/preferences_storage_impl.dart';
import 'core/storage/secure_storage_impl.dart';
import 'core/storage/session_storage_impl.dart';
import 'features/auth/presentation/auth_notifier.dart';
import 'features/auth/data/auth_repository.dart';
import 'routing/app_router.dart';
import 'theme/extensions/theme_data_extensions.dart';
import 'theme/theme_data.dart';
import 'theme/theme_notifier.dart';

void main() {
  GlobalErrorHandler.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Single shared SecureStorage implementation for the whole app.
    final secureStorage = SecureStorageImpl();
    final sessionStorage = SecureSessionStorage(storage: secureStorage);
    final preferencesStorage = SecurePreferencesStorage(storage: secureStorage);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(
            authRepository: AuthRepository(
              sessionStorage: sessionStorage,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(
            preferencesStorage: preferencesStorage,
          ),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          final router = AppRouter.createRouter(context);
          return MaterialApp.router(
            title: 'Flutter Frontend Boilerplate',
            theme: AppThemeData.light().toThemeData(),
            darkTheme: AppThemeData.dark().toThemeData(),
            themeMode: themeNotifier.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
