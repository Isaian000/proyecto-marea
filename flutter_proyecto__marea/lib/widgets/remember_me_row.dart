// widgets/auth/remember_me_row.dart
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
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            activeColor: AppColors.sage,
            onChanged: (v) => onChanged(v ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Text('Recuérdame', style: AppTextStyles.small),
        const Spacer(),
        GestureDetector(
          onTap: onForgotPassword,
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: AppTextStyles.smallBold,
          ),
        ),
      ],
    );
  }
}
