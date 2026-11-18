import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../models/app_notification.dart';
import '../../../providers/notifications_provider.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/notification_card.dart';

// Notificaciones del usuario desde Firestore.
// Deslizar hacia abajo las vuelve a cargar.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationsProvider>().load();
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _markAsRead(AppNotification notification) async {
    try {
      await context.read<NotificationsProvider>().markAsRead(notification.id);
    } catch (e) {
      if (mounted) _showMessage('No se pudo marcar como leída.');
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await context.read<NotificationsProvider>().markAllAsRead();
    } catch (e) {
      if (mounted) _showMessage('No se pudieron marcar como leídas.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.load,
          child: ListView(
            // Permite deslizar para recargar aunque la lista sea corta.
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            children: [
              Row(
                children: [
                  RoundIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  // Flexible: si no cabe en una línea (pantallas angostas o
                  // letra grande), el texto pasa a dos líneas en vez de
                  // salirse de la pantalla.
                  if (provider.unreadCount > 0)
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _markAllAsRead,
                          child: const Text(
                            'Marcar todas como leídas',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Notificaciones',
                style: TextStyle(
                  color: textColor(context),
                  fontFamily: 'Georgia',
                  fontFamilyFallback: const ['serif'],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              ..._content(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, NotificationsProvider provider) {
    final items = provider.items;

    if (provider.loading && items.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (items.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            provider.error ??
                'No tienes notificaciones por ahora.\n'
                    'Desliza hacia abajo para actualizar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedColor(context), height: 1.5),
          ),
        ),
      ];
    }

    final groups = AppNotification.group(items, DateTime.now());
    return [
      for (final section in NotificationSection.values)
        if (groups[section] != null) ...[
          NotificationSectionTitle(section.label),
          const SizedBox(height: 8),
          for (final notification in groups[section]!) ...[
            NotificationCard(
              icon: notification.icon,
              title: notification.title,
              message: notification.body,
              unread: !notification.read,
              onTap: () => _markAsRead(notification),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
        ],
    ];
  }
}
