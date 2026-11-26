import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../providers/notifications_provider.dart';
import '../../../providers/records_provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Carga los registros y los avisos del usuario al entrar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RecordsProvider>().load();
      context.read<NotificationsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    const pages = <Widget>[
      TodayScreen(),
      HistoryScreen(),
      PatternsScreen(),
      CommunityForumsScreen(),
      SettingsScreen(),
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
            label: 'Grupos',
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
