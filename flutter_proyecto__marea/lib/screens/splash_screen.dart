import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/marea_brand.dart';

class MareaApp extends StatelessWidget {
  const MareaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.dark,
      body: Center(child: MareaBrand()),
    );
  }

}