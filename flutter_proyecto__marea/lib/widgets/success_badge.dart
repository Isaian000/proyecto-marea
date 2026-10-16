import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';

class SuccessBadge extends StatelessWidget {
  const SuccessBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: surfaceColor(context),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 36, color: AppColors.sage),
    );
  }
}
