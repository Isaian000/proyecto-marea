import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../providers/records_provider.dart';
import '../../../utils/mood_stats.dart';
import '../../../widgets/diary_widgets.dart';

// Patrones calculados con los registros reales del usuario.
class PatternsScreen extends StatefulWidget {
  const PatternsScreen({super.key});

  @override
  State<PatternsScreen> createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsScreen> {
  int period = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecordsProvider>();
    final records = provider.items;
    final summary = MoodStats.patternSummary(records);

    return RefreshIndicator(
      onRefresh: provider.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        children: [
          const TopHeader(
            title: 'Patrones',
            subtitle: 'Tu marea emocional',
            showProfile: true,
          ),
          const SizedBox(height: 20),
          SegmentedTabs(
            labels: const ['Semana', 'Mes'],
            selected: period,
            onSelected: (value) => setState(() => period = value),
          ),
          const SizedBox(height: 14),
          if (period == 0)
            WeeklyPattern(
              week: [
                for (final r in MoodStats.week(records, provider.today))
                  r?.mood,
              ],
              averages: MoodStats.weekdayAverages(records),
            )
          else
            MonthlyPattern(
              days: [
                for (final r in MoodStats.lastFourWeeks(
                  records,
                  provider.today,
                ))
                  r?.color,
              ],
            ),
          const SizedBox(height: 14),
          CreamCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE6E4E2),
                  child: Icon(Icons.auto_awesome, color: blue),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SerifText(
                        'Patrón detectado',
                        color: ink,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        summary ??
                            'Registra cómo te sientes en días distintos de la '
                                'semana para descubrir tus patrones.',
                        style: const TextStyle(color: ink, height: 1.4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        records.length == 1
                            ? 'Basado en 1 registro'
                            : 'Basado en ${records.length} registros',
                        style: const TextStyle(
                          color: Color(0xFF777269),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
