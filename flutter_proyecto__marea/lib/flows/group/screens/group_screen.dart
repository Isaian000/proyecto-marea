import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';
import 'conversation_zone_screen.dart';
import 'interaction_zone_screen.dart';
import 'resources_screen.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({
    super.key,
    required this.name,
    required this.topic,
    required this.members,
    required this.color,
  });
  final String name;
  final String topic;
  final String members;
  final Color color;

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _showReviews(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Las reseñas estarán disponibles pronto')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          children: [
            PageHeader(
              title: name,
              subtitle: members,
              trailing: IconAvatar(icon: Icons.people_outline, color: color),
            ),
            const SizedBox(height: 20),
            RatingCard(onReviews: () => _showReviews(context)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SerifText(
                    'Políticas del grupo',
                    color: ink,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 14),
                  PolicyRow(
                    icon: Icons.chat_bubble_outline,
                    text: 'Respeto mutuo: todos los comentarios deben ser empáticos.',
                  ),
                  PolicyRow(
                    icon: Icons.check,
                    text: 'Sin juicios: este es un espacio libre de críticas o burlas.',
                  ),
                  PolicyRow(
                    icon: Icons.lock_outline,
                    text:
                        'Confidencialidad: lo que se dice aquí, se queda aquí.',
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Color(0xFFDDD5C7),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nivel de actividad',
                    style: TextStyle(
                      color: ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Alta participación. Más de 300 mensajes esta semana y respuestas promedio en menos de 1 h.',
                    style: TextStyle(color: grey, fontSize: 13, height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GroupOption(
              icon: Icons.menu_book_outlined,
              label: 'Recursos útiles',
              onPressed: () => _open(context, ResourcesScreen(topic: topic)),
            ),
            GroupOption(
              icon: Icons.chat_bubble_outline,
              label: 'Zona de conversación',
              onPressed: () => _open(context, const ConversationZoneScreen()),
            ),
            GroupOption(
              icon: Icons.people_outline,
              label: 'Zona de interacción',
              onPressed: () => _open(context, const InteractionZoneScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
