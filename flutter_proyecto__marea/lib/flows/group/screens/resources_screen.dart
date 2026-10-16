import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../../widgets/group_widgets.dart';
import 'article_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key, required this.topic});
  final String topic;

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _query = '';

  final List<String> _titles = [
    '¿Qué es la ansiedad generalizada?',
    'Apps que ayudan a tu ansiedad',
    '¿Qué hacer en un ataque de pánico?',
    '¿Cómo hablar de tu ansiedad con los demás?',
  ];
  final List<String> _descriptions = [
    'Qué significa vivir con ansiedad constante, sus causas, síntomas y cómo buscar ayuda profesional.',
    'Herramientas móviles recomendadas por psicólogos para respirar, meditar y organizar tus pensamientos.',
    'Guía breve con ejercicios de respiración y técnicas para recuperar el control en situaciones difíciles.',
    'Consejos prácticos para comunicarte con familia, amigos o compañeros sin sentir culpa ni vergüenza.',
  ];

  void _openResource(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ArticleScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Este recurso estará disponible pronto'),
          ),
        );
    }
  }

  List<Widget> _buildCards() {
    List<Widget> cards = [];
    for (int i = 0; i < _titles.length; i++) {
      if (_titles[i].toLowerCase().contains(_query.toLowerCase())) {
        cards.add(
          ResourceCard(
            title: _titles[i],
            description: _descriptions[i],
            onPressed: () => _openResource(i),
          ),
        );
      }
    }
    if (cards.isEmpty) {
      cards.add(
        Text(
          'No encontramos recursos con esa búsqueda.',
          style: TextStyle(color: mutedColor(context)),
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
            PageHeader(
              title: 'Recursos útiles',
              subtitle: 'Lecturas breves del grupo de ${widget.topic}',
            ),
            const SizedBox(height: 18),
            DarkTextField(
              hint: 'Buscar',
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ..._buildCards(),
          ],
        ),
      ),
    );
  }
}
