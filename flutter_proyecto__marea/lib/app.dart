import 'package:flutter/material.dart';

import 'core/app_colors.dart';
import 'flows/auth/screens/splash_screen.dart';

class MareaApp extends StatelessWidget {
  const MareaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          brightness: Brightness.dark,
          surface: navy,
        ),
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: cream),
          bodyMedium: TextStyle(color: cream),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
