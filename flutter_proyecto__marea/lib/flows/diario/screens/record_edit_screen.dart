import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/emotional_record.dart';
import '../../../providers/records_provider.dart';
import '../../../widgets/diary_widgets.dart';

// Edita un registro del diario (ánimo, nota y seguimiento).
class RecordEditScreen extends StatefulWidget {
  const RecordEditScreen({super.key, required this.record});

  final EmotionalRecord record;

  @override
  State<RecordEditScreen> createState() => _RecordEditScreenState();
}

class _RecordEditScreenState extends State<RecordEditScreen> {
  late double mood = widget.record.mood;
  late final noteController = TextEditingController(text: widget.record.note);
  late int energy = EmotionalRecord.energyOptions.indexOf(
    widget.record.energy ?? '',
  );
  late int sleep = EmotionalRecord.sleepOptions.indexOf(
    widget.record.sleep ?? '',
  );
  late int thoughts = EmotionalRecord.thoughtsOptions.indexOf(
    widget.record.thoughts ?? '',
  );
  bool _saving = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  String? _option(List<String> options, int index) =>
      index < 0 ? null : options[index];

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await context.read<RecordsProvider>().update(
        widget.record.copyWith(
          mood: mood,
          note: noteController.text.trim(),
          energy: _option(EmotionalRecord.energyOptions, energy),
          sleep: _option(EmotionalRecord.sleepOptions, sleep),
          thoughts: _option(EmotionalRecord.thoughtsOptions, thoughts),
        ),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );
      navigator.pop();
    } catch (e) {
      debugPrint('No se pudo actualizar el registro: $e');
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar. Revisa tu conexión.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.record.date;
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
                    'Editar registro',
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${longDay(date.weekday)}, ${date.day} de ${monthName(date.month)}',
                    style: TextStyle(color: mutedColor(context)),
                  ),
                  const SizedBox(height: 20),
                  MoodSlider(
                    value: mood,
                    onChanged: (value) => setState(() => mood = value),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SerifText(
                      'Me sentí ${EmotionalRecord.labelForMood(mood).toLowerCase()}',
                      size: 20,
                      italic: true,
                    ),
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
                    const Text(
                      '¿Qué pasó?',
                      style: TextStyle(
                        color: ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: noteController,
                      minLines: 2,
                      maxLines: 5,
                      style: const TextStyle(color: ink, height: 1.45),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: .75),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDD5C7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ChoiceGroup(
                      question: 'Energía',
                      options: EmotionalRecord.energyOptions,
                      selected: energy,
                      onSelected: (value) => setState(() => energy = value),
                    ),
                    const SizedBox(height: 16),
                    ChoiceGroup(
                      question: 'Sueño',
                      options: EmotionalRecord.sleepOptions,
                      selected: sleep,
                      onSelected: (value) => setState(() => sleep = value),
                    ),
                    const SizedBox(height: 16),
                    ChoiceGroup(
                      question: 'Pensamientos',
                      options: EmotionalRecord.thoughtsOptions,
                      selected: thoughts,
                      onSelected: (value) => setState(() => thoughts = value),
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      label: _saving ? 'Guardando...' : 'Guardar cambios',
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
