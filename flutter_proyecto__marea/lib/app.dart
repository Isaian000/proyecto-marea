import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'flows/auth/screens/splash_screen.dart';

class MareaApp extends StatefulWidget {
  const MareaApp({super.key});

  // BUSCA EL ESTADO DE MAREAAPP HACIA ARRIBA EN EL ARBOL PARA QUE
  // CUALQUIER PANTALLA PUEDA LEER O CAMBIAR EL MODO OSCURO
  static MareaAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MareaAppState>()!;
  }

  @override
  State<MareaApp> createState() => MareaAppState();
}

class MareaAppState extends State<MareaApp> {
  bool darkMode = true;

  void setDarkMode(bool value) {
    setState(() {
      darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marea',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
