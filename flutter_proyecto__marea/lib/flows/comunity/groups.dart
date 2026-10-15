import 'package:flutter/material.dart';

import '../diario/my_app.dart';

const _slate = Color(0xFF7F97A8);
const _grey = Color(0xFF7B868C);

// Pantalla principal de Comunidad: pestañas "Foros" y "Mis grupos".
// Va dentro de DiaryShell, que ya pone la barra de navegación inferior.
class CommunityForumsPage extends StatefulWidget {
  const CommunityForumsPage({super.key});

  @override
  State<CommunityForumsPage> createState() => _CommunityForumsPageState();
}

class _CommunityForumsPageState extends State<CommunityForumsPage> {
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
  final List<Color> _forumColors = [_slate, blue, gold];

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
      page = const ForumIntroPage(
        title: 'Hablemos de ansiedad',
        question: '¿Te has sentido abrumado, con pensamientos que no se detienen o con una constante sensación de inquietud?',
        description: 'No estás solo. Te invitamos a un espacio seguro donde podrás compartir, escuchar y aprender sobre la ansiedad junto a otras personas que te comprenden. Hablar de lo que sentimos es el primer paso para sanar.',
        color: _slate,
      );
    } else if (_category == 1) {
      page = const ForumIntroPage(
        title: 'Hablemos de depresión',
        question: 'A veces la tristeza pesa más de lo que podemos expresar.',
        description: 'Si te has sentido sin energía, desmotivado o desconectado de todo, queremos que sepas que no estás solo. Este foro es un espacio empático y seguro para hablar sobre la depresión y encontrar apoyo real.',
        color: blue,
      );
    } else {
      page = const ForumIntroPage(
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
            color: _slate,
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
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? teal : navyLight,
        foregroundColor: selected ? ink : cream,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// Círculo de color con el ícono de chat, usado en las tarjetas.
class ChatCircle extends StatelessWidget {
  const ChatCircle({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const Icon(Icons.chat_bubble_outline, color: cream, size: 20),
    );
  }
}

// "Público" con globo o "Privado" con candado.
class PrivacyLabel extends StatelessWidget {
  const PrivacyLabel({super.key, required this.isPublic});
  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isPublic ? Icons.public : Icons.lock_outline,
          size: 16,
          color: _grey,
        ),
        const SizedBox(width: 6),
        Text(
          isPublic ? 'Público' : 'Privado',
          style: const TextStyle(color: _grey, fontSize: 13),
        ),
      ],
    );
  }
}

// Botón pequeño de las tarjetas: relleno (teal) o con borde.
class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onPressed,
  });
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: ink,
        ),
        child: Text(label, style: textStyle),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        side: const BorderSide(color: _grey),
      ),
      child: Text(label, style: textStyle),
    );
  }
}

// Tarjeta de un foro, ej. "Foro de ansiedad 1".
class ForumCard extends StatelessWidget {
  const ForumCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isPublic,
    required this.onPressed,
  });
  final String title;
  final String subtitle;
  final Color color;
  final bool isPublic;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ChatCircle(color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrivacyLabel(isPublic: isPublic),
              CardButton(
                label: isPublic ? 'Unirse' : 'Mandar solicitud',
                filled: isPublic,
                onPressed: onPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Tarjeta de un grupo en "Mis grupos", ej. "Grupo Ansiedad".
class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.name,
    required this.members,
    required this.color,
    required this.isPublic,
    required this.onPressed,
  });
  final String name;
  final String members;
  final Color color;
  final bool isPublic;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ChatCircle(color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      members,
                      style: const TextStyle(color: _grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrivacyLabel(isPublic: isPublic),
              CardButton(label: 'Entrar', filled: true, onPressed: onPressed),
            ],
          ),
        ],
      ),
    );
  }
}

// "Hablemos de ansiedad / depresión / estrés social".
class ForumIntroPage extends StatelessWidget {
  const ForumIntroPage({
    super.key,
    required this.title,
    required this.question,
    required this.description,
    required this.color,
  });
  final String title;
  final String question;
  final String description;
  final Color color;

  void _register(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ForumJoinedPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RoundIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SerifText(title, size: 28, weight: FontWeight.bold),
                    const SizedBox(height: 18),
                    ForumIntroArt(color: color),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question,
                            style: const TextStyle(
                              color: ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            description,
                            style: const TextStyle(
                              color: ink,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Registrarme',
                  onPressed: () => _register(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Círculos concéntricos del color del foro con el ícono de chat al centro.
// Los anillos grandes se salen de la tarjeta y el Stack los recorta.
class ForumIntroArt extends StatelessWidget {
  const ForumIntroArt({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: navyLight,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -90,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -35,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .22),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: cream,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// "Registro exitoso".
class ForumJoinedPage extends StatelessWidget {
  const ForumJoinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: teal.withValues(alpha: .2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: teal, size: 40),
              ),
              const SizedBox(height: 24),
              const SerifText(
                'Registro exitoso',
                size: 28,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu registro en el foro se realizó con éxito.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 14),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Comenzar',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
