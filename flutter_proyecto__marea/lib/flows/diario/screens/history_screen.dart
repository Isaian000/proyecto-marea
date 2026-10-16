import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
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
    return widget.records
        .where((item) => !item.date.isBefore(from) && !item.date.isAfter(to))
        .toList();
  }

  Future<void> pickDate(bool isFrom) async {
    final current = isFrom ? from : to;
    final selected = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (selected != null) {
      setState(() {
        if (isFrom) {
          from = selected;
        } else {
          to = selected;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = visibleRecords;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
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
                      style: const TextStyle(color: muted),
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
          ...shown.map(
            (record) => Padding(
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
          ),
        ],
      ),
    );
  }
}
