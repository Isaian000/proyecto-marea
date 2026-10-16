import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: surfaceColor(context),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: textColor(context)),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Notificaciones',
                style: TextStyle(
                  color: textColor(context),
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['serif'],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              const NotificationSectionTitle('Hoy'),
              const SizedBox(height: 8),
              const NotificationCard(
                icon: Icons.monitor_heart_outlined,
                title: 'Diario',
                message: 'No olvides tu registro de hoy. Nos encantaría saber cómo te sientes.',
                unread: true,
              ),
              const SizedBox(height: 20),
              const NotificationSectionTitle('Ayer'),
              const SizedBox(height: 8),
              const NotificationCard(
                icon: Icons.people_outline,
                title: 'Foros',
                message: '¿Te gustaría unirte a uno de nuestros foros? Anímate a hablar con personas que se sienten como tú.',
              ),
              const SizedBox(height: 10),
              const NotificationCard(
                icon: Icons.check,
                title: 'Diario',
                message: 'Completaste el diario de hoy. Esperamos que te haya servido expresar cómo te sientes.',
              ),
              const SizedBox(height: 20),
              const NotificationSectionTitle('Anteriores'),
              const SizedBox(height: 8),
              const NotificationCard(
                icon: Icons.chat_bubble_outline,
                title: 'Comentarios',
                message:
                    'Recibiste un nuevo comentario en el grupo de Ansiedad.',
              ),
              const SizedBox(height: 10),
              const NotificationCard(
                icon: Icons.people_outline,
                title: 'Foros',
                message: 'Gracias por unirte al foro de Depresión.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
