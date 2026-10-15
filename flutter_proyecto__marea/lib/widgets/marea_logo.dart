// widgets/common/marea_logo_mark.dart
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// La píldora con degradado y círculo blanco.
class MareaLogo extends StatelessWidget {
  final double width;
  const MareaLogo({super.key, this.width = 56});

  @override
  Widget build(BuildContext context) {
    final height = width * 0.43;
    final knob = height * 0.72;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all((height - knob) / 2),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
      ),
      child: Container(
        width: knob,
        height: knob,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}