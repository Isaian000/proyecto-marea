import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/profile_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileBackButton(),
              const SizedBox(height: 16),
              const ProfileScreenTitle('Nosotros'),
              const SizedBox(height: 24),
              Container(
                width: 112,
                height: 40,
                padding: const EdgeInsets.all(7),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.blue,
                      Color(0xFFC7B48D),
                      AppColors.orange,
                    ],
                  ),
                ),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Marea',
                style: TextStyle(
                  color: AppColors.cream,
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['serif'],
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Un espacio para cuidar tu bienestar mental.',
                style: TextStyle(color: AppColors.muted, fontSize: 15),
              ),
              const SizedBox(height: 28),
              const ProfileAboutSection(
                title: 'Nuestra misión',
                text: 'Acompañar a cada persona en su camino hacia el bienestar mental, ofreciendo espacios seguros, accesibles y empáticos donde pueda expresarse, aprender y sentirse apoyada.',
              ),
              const SizedBox(height: 26),
              const ProfileAboutSection(
                title: 'Nuestra visión',
                text: 'Ser una comunidad digital referente en salud mental, donde el diálogo, la escucha activa y el cuidado emocional contribuyan a transformar vidas de manera positiva y consciente.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
