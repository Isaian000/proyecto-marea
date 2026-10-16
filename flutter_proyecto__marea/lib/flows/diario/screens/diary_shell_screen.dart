import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/emotional_record.dart';
import '../../community/screens/community_forums_screen.dart';
import '../../settings/screens/settings_screen.dart';
import 'history_screen.dart';
import 'patterns_screen.dart';
import 'today_screen.dart';

class DiaryShellScreen extends StatefulWidget {
  const DiaryShellScreen({super.key});

  @override
  State<DiaryShellScreen> createState() => _DiaryShellScreenState();
}

class _DiaryShellScreenState extends State<DiaryShellScreen> {
  int selectedIndex = 0;
  bool recordSaved = false;
  double mood = 0.72;
  String note =
      'Reunión larga en la mañana, pero salí a caminar 20 min y bajé el estrés.';

  final records = <EmotionalRecord>[
    EmotionalRecord(
      date: DateTime(2025, 9, 5),
      mood: .72,
      moodLabel: 'Bien',
      note: 'Reunión larga en la mañana, pero salí a caminar 20 min y bajé el estrés.',
      color: gold,
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 4),
      mood: .73,
      moodLabel: 'Bien',
      note: 'Terminé una tarea pendiente, se sintió bien avanzar.',
      color: gold,
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 3),
      mood: .50,
      moodLabel: 'Neutral',
      note: 'Día normal, sin sobresaltos.',
      color: Color(0xFFBEAF8B),
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 2),
      mood: .30,
      moodLabel: 'Bajo',
      note: 'Dormí poco, día lento en general.',
      color: Color(0xFF829DB6),
    ),
    EmotionalRecord(
      date: DateTime(2025, 9, 1),
      mood: .18,
      moodLabel: 'Ansioso',
      note: 'Junta de proyecto se movió otra vez, cuesta empezar la semana.',
      color: blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      TodayScreen(
        saved: recordSaved,
        initialMood: mood,
        initialNote: note,
        onSave: (newMood, newNote) {
          setState(() {
            mood = newMood;
            note = newNote;
            recordSaved = true;
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Registro guardado')));
        },
      ),
      HistoryScreen(records: records),
      const PatternsScreen(),
      const CommunityForumsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: NavigationBar(
        height: 82,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: teal,
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Hoy',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Patrones',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Comunidad',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
