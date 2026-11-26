import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/emotional_record.dart';
import '../../../providers/records_provider.dart';
import '../../../widgets/diary_widgets.dart';

// Energía, sueño y pensamientos del día, guardados en el registro de hoy.
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int energy = 2;
  int sleep = 2;
  int thoughts = 2;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Si ya había seguimiento hoy, lo muestra seleccionado.
    final today = context.read<RecordsProvider>().todayRecord;
    energy = _indexOf(EmotionalRecord.energyOptions, today?.energy, energy);
    sleep = _indexOf(EmotionalRecord.sleepOptions, today?.sleep, sleep);
    thoughts = _indexOf(
      EmotionalRecord.thoughtsOptions,
      today?.thoughts,
      thoughts,
    );
  }

  int _indexOf(List<String> options, String? value, int fallback) {
    final index = value == null ? -1 : options.indexOf(value);
    return index < 0 ? fallback : index;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await context.read<RecordsProvider>().saveTracking(
        energy: EmotionalRecord.energyOptions[energy],
        sleep: EmotionalRecord.sleepOptions[sleep],
        thoughts: EmotionalRecord.thoughtsOptions[thoughts],
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Seguimiento guardado')),
      );
      navigator.pop();
    } catch (e) {
      debugPrint('No se pudo guardar el seguimiento: $e');
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar. Revisa tu conexión.')),
      );
    }
  }

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
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    ChoiceGroup(
                      question: '¿Cómo fue tu energía durante el día?',
                      options: EmotionalRecord.energyOptions,
                      selected: energy,
                      onSelected: (value) => setState(() => energy = value),
                    ),
                    const SizedBox(height: 24),
                    ChoiceGroup(
                      question: '¿Cómo calificas tu sueño de anoche?',
                      options: EmotionalRecord.sleepOptions,
                      selected: sleep,
                      onSelected: (value) => setState(() => sleep = value),
                    ),
                    const SizedBox(height: 24),
                    ChoiceGroup(
                      question: '¿Cómo fueron tus pensamientos hoy?',
                      options: EmotionalRecord.thoughtsOptions,
                      selected: thoughts,
                      onSelected: (value) => setState(() => thoughts = value),
                    ),
                    const SizedBox(height: 60),
                    PrimaryButton(
                      label: _saving ? 'Guardando...' : 'Guardar seguimiento',
                      onPressed: _saving ? () {} : _save,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
