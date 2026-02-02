import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/auth_notifier.dart';
import 'routing/app_router.dart';
import 'theme/theme_notifier.dart';
import 'theme/theme_builder.dart';
import 'theme/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          final router = AppRouter.createRouter(context);
          return MaterialApp.router(
            title: 'Flutter Frontend Boilerplate',
            theme: ThemeBuilder.buildThemeData(AppThemeData.light()),
            darkTheme: ThemeBuilder.buildThemeData(AppThemeData.dark()),
            themeMode: themeNotifier.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
