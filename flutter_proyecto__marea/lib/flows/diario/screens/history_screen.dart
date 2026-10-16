import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/emotional_record.dart';
import '../../../widgets/diary_widgets.dart';
import 'record_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.records});

  final List<EmotionalRecord> records;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int period = 0;
  bool dateFilter = false;
  DateTime from = DateTime(2025, 9, 1);
  DateTime to = DateTime(2025, 9, 3);

  List<EmotionalRecord> get visibleRecords {
    if (!dateFilter) return widget.records;
    List<EmotionalRecord> result = [];
    for (int i = 0; i < widget.records.length; i++) {
      EmotionalRecord item = widget.records[i];
      if (!item.date.isBefore(from) && !item.date.isAfter(to)) {
        result.add(item);
      }
    }
    return result;
  }

  List<Widget> _buildRecordCards(List<EmotionalRecord> records) {
    List<Widget> cards = [];
    for (int i = 0; i < records.length; i++) {
      EmotionalRecord record = records[i];
      cards.add(
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
      );
    }
    return cards;
  }

  void selectDate(bool isFrom, DateTime date) {
    setState(() {
      if (isFrom) {
        from = date;
      } else {
        to = date;
      }
    });
  }

  List<Widget> _buildDateOptions(bool isFrom, BuildContext dialogContext) {
    DateTime current = isFrom ? from : to;
    List<Widget> options = [];
    for (int i = widget.records.length - 1; i >= 0; i--) {
      DateTime date = widget.records[i].date;
      options.add(
        ListTile(
          title: Text('${two(date.day)}/${two(date.month)}/${date.year}'),
          trailing: date == current
              ? const Icon(Icons.check, color: teal)
              : null,
          onTap: () {
            selectDate(isFrom, date);
            Navigator.pop(dialogContext);
          },
        ),
      );
    }
    return options;
  }

  void pickDate(bool isFrom) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isFrom ? 'Desde' : 'Hasta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildDateOptions(isFrom, dialogContext),
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
    final shown = visibleRecords;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        dateFilter
                            ? '${shown.length} registros entre estas fechas'
                            : '5 registros esta semana',
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
            SegmentedTabs(
              labels: const ['Semana', 'Mes', 'Todo'],
              selected: period,
              onSelected: (value) => setState(() => period = value),
            ),
            if (dateFilter) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DateBox(
                      label: 'Desde',
                      value: from,
                      onTap: () => pickDate(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DateBox(
                      label: 'Hasta',
                      value: to,
                      onTap: () => pickDate(false),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            ..._buildRecordCards(shown),
          ],
        ),
      ],
    );
  }
}
