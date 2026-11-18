import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/emotional_record.dart';
import '../../../providers/records_provider.dart';
import '../../../widgets/diary_widgets.dart';
import 'record_edit_screen.dart';

// Un registro del diario, con botones para editarlo y borrarlo.
class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key, required this.record});

  final EmotionalRecord record;

  Future<void> _delete(BuildContext context, EmotionalRecord current) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text(
          'Se borrará este registro del diario. No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await context.read<RecordsProvider>().delete(current.id);
      messenger.showSnackBar(
        const SnackBar(content: Text('Registro eliminado')),
      );
      navigator.pop();
    } catch (e) {
      debugPrint('No se pudo eliminar el registro: $e');
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar. Revisa tu conexión.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Toma la versión más reciente por si se acaba de editar.
    final current =
        context.watch<RecordsProvider>().byId(record.id) ?? record;
    final date = current.date;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                RoundIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                RoundIconButton(
                  icon: Icons.edit_outlined,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecordEditScreen(record: current),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                RoundIconButton(
                  icon: Icons.delete_outline,
                  onPressed: () => _delete(context, current),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SerifText(
              '${longDay(date.weekday)}, ${date.day} de ${monthName(date.month)}',
              size: 27,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 5),
            Text(
              'Tu registro del día',
              style: TextStyle(color: mutedColor(context)),
            ),
            const SizedBox(height: 26),
            MoodSlider(value: current.mood),
            const SizedBox(height: 20),
            Center(
              child: SerifText(
                'Me sentí ${current.moodLabel.toLowerCase()}',
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
                    current.note.isEmpty ? 'Sin nota' : current.note,
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
                  DetailRow(
                    label: 'Energía',
                    value: current.energy ?? 'Sin registrar',
                  ),
                  DetailRow(
                    label: 'Sueño',
                    value: current.sleep ?? 'Sin registrar',
                  ),
                  DetailRow(
                    label: 'Pensamientos',
                    value: current.thoughts ?? 'Sin registrar',
                    divider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
