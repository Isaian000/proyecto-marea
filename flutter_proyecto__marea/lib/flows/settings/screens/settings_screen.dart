import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/profile_widgets.dart';
import '../../../widgets/settings_widgets.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../profile/screens/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _changeDarkMode(bool value) {
    setState(() {
      MareaApp.changeDarkMode(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      children: [
        const TopHeader(
          title: 'Ajustes',
          subtitle: 'Personaliza tu experiencia',
          showProfile: true,
        ),
        const SizedBox(height: 28),
        const SettingsSectionTitle('Apariencia'),
        SettingsSwitchTile(
          icon: Icons.dark_mode_outlined,
          title: 'Modo oscuro',
          subtitle: 'Usa colores oscuros en toda la app',
          value: MareaApp.darkMode,
          onChanged: _changeDarkMode,
        ),
        const SizedBox(height: 28),
        const SettingsSectionTitle('Cuenta'),
        ProfileOption(
          icon: Icons.person_outline,
          label: 'Mi perfil',
          onTap: () => _open(const ProfileScreen()),
        ),
        const SizedBox(height: 12),
        ProfileOption(
          icon: Icons.notifications_none,
          label: 'Notificaciones',
          onTap: () => _open(const NotificationsScreen()),
        ),
        const SizedBox(height: 12),
        ProfileOption(
          icon: Icons.logout,
          label: 'Cerrar sesión',
          onTap: () => logOut(context, 1),
        ),
      ],
    );
  }
}
