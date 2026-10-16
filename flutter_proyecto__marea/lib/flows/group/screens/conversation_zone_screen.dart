import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/group_models.dart';
import '../../../widgets/group_widgets.dart';
import 'topic_screen.dart';

class ConversationZoneScreen extends StatelessWidget {
  const ConversationZoneScreen({super.key});

  final List<Topic> topics = const [
    Topic(
      title: '¿Cómo manejan la ansiedad social?',
      author: 'Usuario123',
      time: 'Hace 2 h',
      text: 'Me cuesta mucho hablar con personas nuevas y evito situaciones sociales. ¿Algún consejo?',
      replies: 8,
      votes: 15,
      comments: [
        TopicComment(
          author: 'jorge_m',
          initials: 'JM',
          time: 'Hace 1 h',
          text: 'Yo también siento eso cuando estoy con muchas personas. Lo que me ha ayudado es hacer respiraciones profundas antes de salir.',
          color: slate,
        ),
        TopicComment(
          author: 'ana_lopez',
          initials: 'AL',
          time: 'Hace 40 min',
          text: 'A mí me sirve escribir en mi diario emocional antes de enfrentar esas situaciones. ¡No estás solo!',
          color: gold,
        ),
        TopicComment(
          author: 'valeria_r',
          initials: 'VR',
          time: 'Hace 20 min',
          text: 'Practico afirmaciones positivas. Puede parecer simple, pero me da más seguridad.',
          color: sand,
        ),
      ],
    ),
    Topic(
      title: '¿Alguien más despierta con ansiedad?',
      author: 'Jorge12345',
      time: 'Hace 5 h',
      text: 'Me levanto con el pecho apretado y pensamientos negativos. ¿Cómo lo manejan ustedes?',
      replies: 2,
      votes: 4,
    ),
    Topic(
      title: 'Recomienden apps para dormir mejor',
      author: 'Ana123456',
      time: 'Hace 2 h',
      text: '¿Usan alguna app para relajarse antes de dormir? No he logrado dormir bien en semanas.',
      replies: 4,
      votes: 12,
    ),
  ];

  List<Widget> _buildCards(BuildContext context) {
    List<Widget> cards = [];
    for (int i = 0; i < topics.length; i++) {
      cards.add(
        TopicCard(
          topic: topics[i],
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicScreen(topic: topics[i]),
            ),
          ),
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          children: [
            const PageHeader(
              title: 'Zona de conversación',
              subtitle: 'Temas abiertos del grupo',
            ),
            const SizedBox(height: 20),
            ..._buildCards(context),
          ],
        ),
      ),
    );
  }
}
