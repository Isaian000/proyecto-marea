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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$text ', style: AppTextStyles.small),
        GestureDetector(
          onTap: onTap,
          child: Text(actionLabel, style: AppTextStyles.smallBold),
        ),
      ],
    );
  }
}
