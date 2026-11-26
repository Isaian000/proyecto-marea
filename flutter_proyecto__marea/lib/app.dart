import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'flows/auth/screens/splash_screen.dart';
import 'providers/community_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/records_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

class MareaApp extends StatelessWidget {
  const MareaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // lazy: false para que empiece a escuchar la sesión desde que abre la
        // app, aunque ninguna pantalla lo use todavía.
        ChangeNotifierProvider(create: (_) => UserProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => RecordsProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Marea',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
