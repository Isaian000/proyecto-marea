import 'package:flutter/material.dart';

import '../core/app_text_styles.dart';

class AuthFooterLink extends StatelessWidget {
  final String text;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TEMP FIX
    return Column(
      children: [
        Text(text, textAlign: TextAlign.center, style: AppTextStyles.small),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.smallBold,
          ),
        ),
      ],
    );
  }
}
