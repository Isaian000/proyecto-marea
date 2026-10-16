import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/diary_widgets.dart';
import 'tracking_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({
    super.key,
    required this.saved,
    required this.initialMood,
    required this.initialNote,
    required this.onSave,
  });

  final bool saved;
  final double initialMood;
  final String initialNote;
  final void Function(double mood, String note) onSave;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late double mood;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    mood = widget.initialMood;
    noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  String get feeling {
    if (mood < .25) return 'muy bajo';
    if (mood < .45) return 'bajo';
    if (mood < .65) return 'neutral';
    if (mood < .85) return 'bien';
    return 'muy bien';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      child: widget.saved ? _savedView(context) : _formView(context),
    );
  }

  Widget _formView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TopHeader(
          title: 'Hola, Elena',
          subtitle: 'Viernes, 5 de septiembre',
          showProfile: true,
        ),
        const SizedBox(height: 30),
        MoodSlider(
          value: mood,
          onChanged: (value) => setState(() => mood = value),
        ),
        const SizedBox(height: 24),
        Center(child: SerifText('Me siento $feeling', size: 26, italic: true)),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Desliza el punto en la marea para ajustar',
            style: TextStyle(color: mutedColor(context), fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),
        const WeekDots(),
        const SizedBox(height: 58),
        const Quote(),
        const SizedBox(height: 54),
        CreamCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SerifText(
                '¿Qué pasó hoy?',
                color: ink,
                size: 18,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                minLines: 2,
                maxLines: 4,
                style: const TextStyle(color: ink, height: 1.45),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .75),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFDDD5C7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFDDD5C7)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Guardar registro',
                onPressed: () =>
                    widget.onSave(mood, noteController.text.trim()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _savedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreamCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 7, backgroundColor: gold),
                  const SizedBox(width: 10),
                  SerifText(
                    'Hoy te sientes $feeling',
                    color: ink,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MoodSlider(value: mood),
              const SizedBox(height: 14),
              Text(
                noteController.text,
                style: const TextStyle(color: Color(0xFF777269), height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TrackingScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surfaceColor(context),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(Icons.monitor_heart_outlined),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seguimiento del día',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Energía, sueño y pensamientos',
                        style: TextStyle(
                          color: mutedColor(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: mutedColor(context)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Quote(alignedLeft: true),
        const SizedBox(height: 22),
        CreamCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SerifText(
                'Avisos',
                color: ink,
                size: 18,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 12),
              Notice(
                icon: Icons.menu_book_outlined,
                text: 'Nuevo recurso: Técnicas de respiración',
              ),
              SizedBox(height: 14),
              Notice(
                icon: Icons.chat_bubble_outline,
                text: '2 mensajes nuevos en tu grupo',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
