import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/diary_widgets.dart';

class PatternsScreen extends StatefulWidget {
  const PatternsScreen({super.key});

  @override
  State<PatternsScreen> createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsScreen> {
  int period = 0;
  final colors = const [
    blue,
    Color(0xFF829DB6),
    Color(0xFFBEAF8B),
    gold,
    Color(0xFF829DB6),
    gold,
    orange,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopHeader(
            title: 'Patrones',
            subtitle: 'Tu marea emocional',
            showProfile: true,
          ),
          const SizedBox(height: 20),
          SegmentedTabs(
            labels: const ['Semana', 'Mes', 'Todo'],
            selected: period,
            onSelected: (value) => setState(() => period = value),
          ),
          const SizedBox(height: 14),
          if (period == 0)
            WeeklyPattern(colors: colors)
          else
            MonthlyPattern(colors: colors),
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
                    children: const [
                      SerifText(
                        'Patrón detectado',
                        color: ink,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sueles sentirte más bajo los lunes y más cansado los viernes.',
                        style: TextStyle(color: ink, height: 1.4),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Basado en tus últimos 30 registros',
                        style: TextStyle(
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
