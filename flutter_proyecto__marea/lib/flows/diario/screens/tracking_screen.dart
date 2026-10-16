import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/diary_widgets.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int energy = 2;
  int sleep = 2;
  int thoughts = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
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
                  const SizedBox(height: 16),
                  const SerifText(
                    'Seguimiento',
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tres preguntas rápidas sobre tu día',
                    style: TextStyle(color: mutedColor(context)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChoiceGroup(
                        question: '¿Cómo fue tu energía durante el día?',
                        options: const [
                          'Muy baja',
                          'Baja',
                          'Activa',
                          'Muy activa',
                        ],
                        selected: energy,
                        onSelected: (value) => setState(() => energy = value),
                      ),
                      const SizedBox(height: 24),
                      ChoiceGroup(
                        question: '¿Cómo calificas tu sueño de anoche?',
                        options: const [
                          'No dormí casi nada',
                          'Dormí poco',
                          'Dormí lo necesario',
                          'Dormí excelente',
                        ],
                        selected: sleep,
                        onSelected: (value) => setState(() => sleep = value),
                      ),
                      const SizedBox(height: 24),
                      ChoiceGroup(
                        question: '¿Cómo fueron tus pensamientos hoy?',
                        options: const [
                          'Negativos',
                          'Algo negativos',
                          'Neutrales',
                          'Positivos',
                        ],
                        selected: thoughts,
                        onSelected: (value) => setState(() => thoughts = value),
                      ),
                      const SizedBox(height: 60),
                      PrimaryButton(
                        label: 'Guardar seguimiento',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seguimiento guardado'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
