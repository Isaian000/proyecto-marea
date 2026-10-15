import 'package:flutter/material.dart';

import '../diario/my_app.dart';

const slate = Color(0xFF7F97A8);
const sand = Color(0xFFB9A88A);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;

  final List<Widget> _slides = const [
    OnboardingSlide(
      illustration: WelcomeArt(),
      title: 'Te damos la bienvenida',
      subtitle:
          'Regístrate para empezar a usar Marea y personalizar tu experiencia.',
    ),
    OnboardingSlide(
      illustration: FormArt(),
      title: 'Llena tus datos',
      subtitle: 'Nombre, edad, género y más. Es rápido y fácil.',
    ),
    OnboardingSlide(
      illustration: PreferencesArt(),
      title: 'Elige tus preferencias',
      subtitle: 'Selecciona tus intereses para personalizar el contenido.',
    ),
    OnboardingSlide(
      illustration: SecureArt(),
      title: 'Información segura',
      subtitle: 'Mantenemos tu información privada y segura.',
    ),
    OnboardingSlide(
      illustration: ReadyArt(),
      title: 'Todo listo para comenzar',
      subtitle: 'Ya puedes explorar el foro y participar en la comunidad.',
    ),
  ];

  void _next() {
    if (_page == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiaryShell()),
      );
    } else {
      setState(() {
        _page = _page + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Siguiente';
    if (_page == 4) {
      buttonText = 'Empezar';
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(child: _slides[_page]),
              const SizedBox(height: 24),
              PageDots(current: _page),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(label: buttonText, onPressed: _next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.illustration,
    required this.title,
    required this.subtitle,
  });
  final Widget illustration;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: navyLight,
              borderRadius: BorderRadius.circular(22),
            ),
            child: illustration,
          ),
          const SizedBox(height: 28),
          SerifText(title, size: 28, weight: FontWeight.w600),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(color: muted, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dot(active: current == 0),
        Dot(active: current == 1),
        Dot(active: current == 2),
        Dot(active: current == 3),
        Dot(active: current == 4),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key, required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? teal : Colors.white24,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// Barra redondeada; left y right controlan dónde empieza y termina.
class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.color,
    required this.left,
    required this.right,
  });
  final Color color;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      margin: EdgeInsets.only(left: left, right: right, bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }
}

class WelcomeArt extends StatelessWidget {
  const WelcomeArt({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Bar(color: blue, left: 66, right: 45),
        Bar(color: slate, left: 121, right: 28),
        Bar(color: sand, left: 52, right: 28),
        Bar(color: gold, left: 148, right: 28),
        Bar(color: orange, left: 90, right: 28),
      ],
    );
  }
}

// Campo blanco del formulario de FormArt.
class FormLine extends StatelessWidget {
  const FormLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6E0D0)),
      ),
    );
  }
}

class FormArt extends StatelessWidget {
  const FormArt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 82, height: 4, color: ink),
                    const SizedBox(height: 6),
                    Container(
                      width: 50,
                      height: 4,
                      color: const Color(0xFFDDD8C4),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const FormLine(),
            const FormLine(),
            const FormLine(),
          ],
        ),
      ),
    );
  }
}

class PreferencesArt extends StatelessWidget {
  const PreferencesArt({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InterestChip(label: 'Ansiedad', selected: true),
            SizedBox(width: 12),
            InterestChip(label: 'Diario', selected: false),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InterestChip(label: 'Depresión', selected: false),
            SizedBox(width: 12),
            InterestChip(label: 'Recursos', selected: true),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InterestChip(label: 'Social', selected: true),
            SizedBox(width: 12),
            InterestChip(label: 'Comunidad', selected: false),
          ],
        ),
      ],
    );
  }
}

class InterestChip extends StatelessWidget {
  const InterestChip({super.key, required this.label, required this.selected});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? teal : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? teal : cream),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? ink : cream,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SecureArt extends StatelessWidget {
  const SecureArt({super.key});

  @override
  Widget build(BuildContext context) {
    // Círculos uno dentro de otro, cada uno un poco más claro.
    return Center(
      child: Container(
        width: 180,
        height: 180,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 130,
          height: 130,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 86,
            height: 86,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: cream,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, color: ink, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

// Punto de color de ReadyArt; left lo mueve a la derecha.
class ColorDot extends StatelessWidget {
  const ColorDot({super.key, required this.color, required this.left});
  final Color color;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class ReadyArt extends StatelessWidget {
  const ReadyArt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 56, 40, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ColorDot(color: orange, left: 232),
          const SizedBox(height: 28),
          const ColorDot(color: gold, left: 177),
          const SizedBox(height: 25),
          const ColorDot(color: sand, left: 122),
          const SizedBox(height: 19),
          const ColorDot(color: slate, left: 67),
          const SizedBox(height: 16),
          const ColorDot(color: blue, left: 15),
          const SizedBox(height: 11),
          Container(
            height: 38,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              gradient: const LinearGradient(colors: [blue, sand, orange]),
            ),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
