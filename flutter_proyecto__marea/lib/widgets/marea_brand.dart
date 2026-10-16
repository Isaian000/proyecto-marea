import 'package:flutter/material.dart';

import '../core/app_text_styles.dart';
import 'marea_logo.dart';

class MareaBrand extends StatelessWidget {
  const MareaBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MareaLogo(width: 68),
        const SizedBox(height: 20),
        Text('Marea', style: AppTextStyles.titleOnDark(44)),
        const SizedBox(height: 8),
        Text('Tu diario emocional', style: AppTextStyles.subtitleOnDark),
      ],
    );
  }
}
