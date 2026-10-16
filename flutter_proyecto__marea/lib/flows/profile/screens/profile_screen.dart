import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/profile_widgets.dart';
import 'about_screen.dart';
import 'account_screen.dart';
import 'personal_information_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileBackButton(),
              const SizedBox(height: 16),
              const ProfileScreenTitle('Mi perfil'),
              const SizedBox(height: 28),
              const CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.gold,
                child: Text(
                  'EM',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontFamily: 'Georgia',
                    fontFamilyFallback: ['serif'],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Elena Martin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.cream,
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['serif'],
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'elenamartin52@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 15),
              ),
              const SizedBox(height: 32),
              ProfileOption(
                icon: Icons.person_outline,
                label: 'Información personal',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PersonalInformationScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ProfileOption(
                icon: Icons.lock_outline,
                label: 'Correo y contraseña',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountScreen()),
                ),
              ),
              const SizedBox(height: 12),
              ProfileOption(
                icon: Icons.info_outline,
                label: 'Nosotros',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.cream,
                  side: const BorderSide(color: Color(0xFF718087)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada')),
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
