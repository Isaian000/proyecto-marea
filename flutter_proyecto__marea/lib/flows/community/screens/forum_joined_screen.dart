import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/diary_widgets.dart';

class ForumJoinedScreen extends StatelessWidget {
  const ForumJoinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: teal.withValues(alpha: .2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: teal, size: 40),
              ),
              const SizedBox(height: 24),
              const SerifText(
                'Registro exitoso',
                size: 28,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              Text(
                'Tu registro en el foro se realizó con éxito.',
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedColor(context), fontSize: 14),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Comenzar',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
