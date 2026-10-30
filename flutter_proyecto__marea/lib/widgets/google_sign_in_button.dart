// boton blanco de "Continuar con Google" con el estilo de MareaButton
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: Color(0xFFDDD5C7)),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'G',
              style: TextStyle(
                color: Color(0xFF4285F4),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text('Continuar con Google', style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }
}
