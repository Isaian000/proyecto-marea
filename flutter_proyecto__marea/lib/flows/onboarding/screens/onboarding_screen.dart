import 'package:flutter/material.dart';

import '../../../widgets/diary_widgets.dart';
import '../../../widgets/onboarding_widgets.dart';
import '../../diario/screens/diary_shell_screen.dart';

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
      NavigatorState navigator = Navigator.of(context);
      navigator.pop();
      navigator.push(
        MaterialPageRoute(builder: (context) => const DiaryShellScreen()),
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
