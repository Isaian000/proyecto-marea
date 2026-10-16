import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/community_widgets.dart';
import '../../../widgets/diary_widgets.dart';
import 'forum_intro_screen.dart';

// Pantalla principal de Comunidad: pestañas "Foros" y "Mis grupos".
// Va dentro de DiaryShell, que ya pone la barra de navegación inferior.
class CommunityForumsScreen extends StatefulWidget {
  const CommunityForumsScreen({super.key});

  @override
  State<CommunityForumsScreen> createState() => _CommunityForumsScreenState();
}

class _CommunityForumsScreenState extends State<CommunityForumsScreen> {
  int _tab = 0; // 0 = Foros, 1 = Mis grupos
  int _category = 0; // 0 = Ansiedad, 1 = Depresión, 2 = Social

  // Datos de cada categoría, en el mismo orden que _category.
  final List<String> _forumNames = [
    'Foro de ansiedad',
    'Foro de depresión',
    'Foro de ansiedad social',
  ];
  final List<String> _forumSubtitles = [
    'Para platicar sobre la ansiedad',
    'Para platicar sobre la depresión',
    'Para platicar sobre ansiedad social',
  ];
  final List<Color> _forumColors = [slate, blue, gold];

  void _selectTab(int index) {
    setState(() {
      _tab = index;
    });
  }

  void _selectCategory(int index) {
    setState(() {
      _category = index;
    });
  }

  // Se llama al presionar "Unirse" en un foro público.
  void _openForumIntro() {
    Widget page;
    if (_category == 0) {
      page = const ForumIntroScreen(
        title: 'Hablemos de ansiedad',
        question: '¿Te has sentido abrumado, con pensamientos que no se detienen o con una constante sensación de inquietud?',
        description: 'No estás solo. Te invitamos a un espacio seguro donde podrás compartir, escuchar y aprender sobre la ansiedad junto a otras personas que te comprenden. Hablar de lo que sentimos es el primer paso para sanar.',
        color: slate,
      );
    } else if (_category == 1) {
      page = const ForumIntroScreen(
        title: 'Hablemos de depresión',
        question: 'A veces la tristeza pesa más de lo que podemos expresar.',
        description: 'Si te has sentido sin energía, desmotivado o desconectado de todo, queremos que sepas que no estás solo. Este foro es un espacio empático y seguro para hablar sobre la depresión y encontrar apoyo real.',
        color: blue,
      );
    } else {
      page = const ForumIntroScreen(
        title: 'Hablemos de estrés social',
        question: '¿Te cuesta hablar en público, iniciar conversaciones o sentirte cómodo en reuniones sociales?',
        description: 'La ansiedad social puede ser muy difícil, pero no tienes que afrontarla solo. Te invitamos a un espacio de comprensión y apoyo donde podrás compartir tus experiencias con personas que te entienden.',
        color: gold,
      );
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // Se llama al presionar "Mandar solicitud" en un foro privado.
  void _sendRequest() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Solicitud enviada')));
  }

  // Arma las 3 tarjetas de la categoría seleccionada.
  List<Widget> _buildForumCards() {
    List<Widget> cards = [];
    for (int i = 1; i <= 3; i++) {
      // El foro 1 siempre es público; el 2 solo en ansiedad; el 3 es privado.
      bool isPublic = i == 1 || (i == 2 && _category == 0);
      cards.add(
        ForumCard(
          title: '${_forumNames[_category]} $i',
          subtitle: _forumSubtitles[_category],
          color: _forumColors[_category],
          isPublic: isPublic,
          onPressed: isPublic ? _openForumIntro : _sendRequest,
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      children: [
        TopHeader(
          title: 'Comunidad',
          subtitle: _tab == 0 ? 'Foros de apoyo' : 'Tus grupos',
          showProfile: true,
        ),
        const SizedBox(height: 20),
        SegmentedTabs(
          labels: const ['Foros', 'Mis grupos'],
          selected: _tab,
          onSelected: _selectTab,
        ),
        const SizedBox(height: 16),
        if (_tab == 0) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              CategoryChip(
                label: 'Ansiedad',
                selected: _category == 0,
                onTap: () => _selectCategory(0),
              ),
              CategoryChip(
                label: 'Depresión',
                selected: _category == 1,
                onTap: () => _selectCategory(1),
              ),
              CategoryChip(
                label: 'Social',
                selected: _category == 2,
                onTap: () => _selectCategory(2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildForumCards(),
        ] else ...[
          // "Entrar" abrirá la sección 06 (Dentro del grupo).
          GroupCard(
            name: 'Grupo Ansiedad',
            members: '345+ integrantes',
            color: slate,
            isPublic: true,
            onPressed: () {},
          ),
          GroupCard(
            name: 'Grupo Ansiedad Social',
            members: '78 integrantes',
            color: gold,
            isPublic: false,
            onPressed: () {},
          ),
          GroupCard(
            name: 'Grupo Depresión',
            members: '145 integrantes',
            color: blue,
            isPublic: false,
            onPressed: () {},
          ),
        ],
      ],
    );
  }
}

// Filtro de categoría: Ansiedad, Depresión, Social.
