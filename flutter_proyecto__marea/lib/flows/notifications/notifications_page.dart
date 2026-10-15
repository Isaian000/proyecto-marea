import 'package:flutter/material.dart';

const _navy = Color(0xFF1D2B33);
const _navyLight = Color(0xFF253943);
const _cream = Color(0xFFF5F1E8);
const _ink = Color(0xFF263037);
const _muted = Color(0xFFA8B7BA);
const _orange = Color(0xFFF18458);

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: _navyLight),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: _cream),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Notificaciones',
                style: TextStyle(
                  color: _cream,
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['serif'],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              const _SectionTitle('Hoy'),
              const SizedBox(height: 8),
              const NotificationCard(
                icon: Icons.monitor_heart_outlined,
                title: 'Diario',
                message: 'No olvides tu registro de hoy. Nos encantaría saber cómo te sientes.',
                unread: true,
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Ayer'),
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
              const _SectionTitle('Anteriores'),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: _muted, fontSize: 13));
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.unread = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE7E1D2),
            child: Icon(icon, color: _ink, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF777269),
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (unread)
            const Padding(
              padding: EdgeInsets.only(top: 1),
              child: CircleAvatar(radius: 4, backgroundColor: _orange),
            ),
        ],
      ),
    );
  }
}
