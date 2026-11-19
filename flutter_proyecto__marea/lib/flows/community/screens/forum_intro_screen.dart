import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../models/forum.dart';
import '../../../providers/community_provider.dart';
import '../../../widgets/community_widgets.dart';
import '../../../widgets/diary_widgets.dart';
import 'forum_joined_screen.dart';

class ForumIntroScreen extends StatefulWidget {
  const ForumIntroScreen({super.key, required this.forum});
  final Forum forum;

  @override
  State<ForumIntroScreen> createState() => _ForumIntroScreenState();
}

class _ForumIntroScreenState extends State<ForumIntroScreen> {
  bool _saving = false;

  Future<void> _register() async {
    setState(() => _saving = true);
    try {
      await context.read<CommunityProvider>().join(widget.forum);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForumJoinedScreen(forumName: widget.forum.name),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No se pudo completar el registro.')),
        );
    }
    if (mounted) setState(() => _saving = false);
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
                    SerifText(
                      widget.forum.introTitle,
                      size: 28,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 18),
                    ForumIntroArt(color: widget.forum.color),
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
                            widget.forum.question,
                            style: const TextStyle(
                              color: ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.forum.description,
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
                  label: _saving ? 'Registrando...' : 'Registrarme',
                  onPressed: _saving ? () {} : _register,
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
