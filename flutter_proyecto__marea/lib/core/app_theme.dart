import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.sage,
          brightness: Brightness.dark,
        ),
      );
}