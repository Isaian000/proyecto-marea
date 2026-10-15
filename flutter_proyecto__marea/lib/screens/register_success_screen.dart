import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/success_badge.dart';
import '../core/app_text_styles.dart';
import '../widgets/marea_button.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SuccessBadge(),
                    const SizedBox(height: 28),
                    Text('Registro completado',
                        style: AppTextStyles.titleOnDark(26)),
                    const SizedBox(height: 10),
                    Text(
                      'Tu cuenta está lista. Ya puedes empezar tu diario.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitleOnDark,
                    ),
                  ],
                ),
              ),
              MareaButton(
                label: 'Comenzar',
                onPressed: () {
                  // fuga pal home pa
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}