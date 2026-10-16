import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/emotional_record.dart';
import '../../../widgets/diary_widgets.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key, required this.record});

  final EmotionalRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                '${longDay(record.date.weekday)}, ${record.date.day} de septiembre',
                size: 27,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              const Text('Tu registro del día', style: TextStyle(color: muted)),
              const SizedBox(height: 26),
              MoodSlider(value: record.mood),
              const SizedBox(height: 20),
              Center(
                child: SerifText(
                  'Me sentí ${record.moodLabel.toLowerCase()}',
                  size: 26,
                  italic: true,
                ),
              ),
              const SizedBox(height: 36),
              CreamCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SerifText(
                      '¿Qué pasó?',
                      color: ink,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      record.note,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CreamCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SerifText(
                      'Seguimiento',
                      color: ink,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    DetailRow(label: 'Energía', value: record.energy),
                    DetailRow(label: 'Sueño', value: record.sleep),
                    DetailRow(
                      label: 'Pensamientos',
                      value: record.thoughts,
                      divider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
