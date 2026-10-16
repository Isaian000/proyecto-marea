import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'flows/auth/screens/splash_screen.dart';

class MareaApp extends StatefulWidget {
  const MareaApp({super.key});

  static bool darkMode = true;
  static void Function(bool) changeDarkMode = (value) {};

  @override
  State<MareaApp> createState() => _MareaAppState();
}

class _MareaAppState extends State<MareaApp> {
  @override
  void initState() {
    super.initState();
    MareaApp.changeDarkMode = (value) {
      setState(() {
        MareaApp.darkMode = value;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marea',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: MareaApp.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
