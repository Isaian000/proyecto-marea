import 'package:flutter/material.dart';

class MareaApp extends StatelessWidget {
  const MareaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marea',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}