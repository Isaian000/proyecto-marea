// widgets/common/marea_button.dart
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class MareaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MareaButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sage,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
