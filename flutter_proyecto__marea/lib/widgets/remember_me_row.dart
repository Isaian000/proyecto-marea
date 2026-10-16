// fila de recuerdame y olvide contrasena
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class RememberMeRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onForgotPassword;

  const RememberMeRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    // temp fix
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              value: value,
              activeTrackColor: AppColors.sage,
              inactiveTrackColor: Colors.white,
              inactiveThumbColor: AppColors.textMuted,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            Text('Recuérdame', style: AppTextStyles.small),
          ],
        ),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: AppTextStyles.smallBold,
          ),
        ),
      ],
    );
  }
}
