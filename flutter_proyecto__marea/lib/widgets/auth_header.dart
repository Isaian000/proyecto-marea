import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/app_text_styles.dart';
import 'marea_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogo;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: surfaceColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: textColor(context),
                ),
              ),
            ),
          if (showLogo) const MareaLogo(width: 42),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.titleOnDark()),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.subtitleOnDark.copyWith(
              color: mutedColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
