import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/emotional_record.dart';
import '../../../providers/records_provider.dart';
import '../../../widgets/diary_widgets.dart';
import 'record_detail_screen.dart';

// Todos los registros del usuario desde Firestore.
// Deslizar hacia abajo los vuelve a cargar.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // 0 = última semana, 1 = último mes, 2 = todo
  int period = 0;
  bool dateFilter = false;
  DateTime? from;
  DateTime? to;

  List<EmotionalRecord> _visible(RecordsProvider provider) {
    final records = provider.items;
    if (dateFilter) {
      final start = from ?? (records.isEmpty ? provider.today : records.last.date);
      final end = to ?? provider.today;
      return records
          .where((r) => !r.date.isBefore(start) && !r.date.isAfter(end))
          .toList();
    }
    if (period == 2) return records;
    final days = period == 0 ? 7 : 30;
    final today = provider.today;
    final limit = DateTime(today.year, today.month, today.day - (days - 1));
    return records.where((r) => !r.date.isBefore(limit)).toList();
  }

  String _subtitle(int count) {
    final plural = count == 1 ? 'registro' : 'registros';
    if (dateFilter) return '$count $plural entre estas fechas';
    return switch (period) {
      0 => '$count $plural en los últimos 7 días',
      1 => '$count $plural en los últimos 30 días',
      _ => '$count $plural en total',
    };
  }

  void pickDate(bool isFrom, RecordsProvider provider) {
    final dates = provider.items.map((r) => r.date).toList();
    if (dates.isEmpty) return;
    final current = isFrom ? (from ?? dates.last) : (to ?? dates.first);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isFrom ? 'Desde' : 'Hasta'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final date in dates)
                  ListTile(
                    title: Text(
                      '${two(date.day)}/${two(date.month)}/${date.year}',
                    ),
                    trailing: date == current
                        ? const Icon(Icons.check, color: teal)
                        : null,
                    onTap: () {
                      setState(() {
                        if (isFrom) {
                          from = date;
                        } else {
                          to = date;
                        }
                      });
                      Navigator.pop(dialogContext);
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecordsProvider>();
    final shown = _visible(provider);
    final items = provider.items;

    return RefreshIndicator(
      onRefresh: provider.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SerifText(
                      'Historial',
                      size: 28,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitle(shown.length),
                      style: TextStyle(color: mutedColor(context)),
                    ),
                  ],
                ),
              ),
              RoundIconButton(
                icon: Icons.calendar_month_outlined,
                selected: dateFilter,
                onPressed: () => setState(() => dateFilter = !dateFilter),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (!dateFilter)
            SegmentedTabs(
              labels: const ['Semana', 'Mes', 'Todo'],
              selected: period,
              onSelected: (value) => setState(() => period = value),
            ),
          if (dateFilter && items.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: DateBox(
                    label: 'Desde',
                    value: from ?? items.last.date,
                    onTap: () => pickDate(true, provider),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DateBox(
                    label: 'Hasta',
                    value: to ?? items.first.date,
                    onTap: () => pickDate(false, provider),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 14),
          if (provider.loading && items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                provider.error ??
                    (items.isEmpty
                        ? 'Aún no tienes registros.\nGuarda el primero en la pestaña Hoy.'
                        : 'No hay registros en este periodo.'),
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedColor(context), height: 1.5),
              ),
            )
          else
            for (final record in shown)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecordCard(
                  record: record,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecordDetailScreen(record: record),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
