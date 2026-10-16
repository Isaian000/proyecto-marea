import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/community_widgets.dart';
import '../../../widgets/diary_widgets.dart';
import 'forum_joined_screen.dart';

class ForumIntroScreen extends StatelessWidget {
  const ForumIntroScreen({
    super.key,
    required this.title,
    required this.question,
    required this.description,
    required this.color,
  });
  final String title;
  final String question;
  final String description;
  final Color color;

  void _register(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForumJoinedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RoundIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SerifText(title, size: 28, weight: FontWeight.bold),
                    const SizedBox(height: 18),
                    ForumIntroArt(color: color),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question,
                            style: const TextStyle(
                              color: ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            description,
                            style: const TextStyle(
                              color: ink,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Registrarme',
                  onPressed: () => _register(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// anillos del color del foro con icono de chat al centro
