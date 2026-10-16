import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: 'Arial',
    scaffoldBackgroundColor: AppColors.navy,
    cardColor: AppColors.navyLight,
    hintColor: AppColors.muted,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.dark,
      surface: AppColors.navy,
      onSurface: AppColors.cream,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.cream),
      bodyMedium: TextStyle(color: AppColors.cream),
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Arial',
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightSurface,
    hintColor: AppColors.textMuted,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.light,
      surface: AppColors.lightBackground,
      onSurface: AppColors.ink,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.ink),
      bodyMedium: TextStyle(color: AppColors.ink),
    ),
  );
}

Color surfaceColor(BuildContext context) => Theme.of(context).cardColor;

Color textColor(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color mutedColor(BuildContext context) => Theme.of(context).hintColor;
