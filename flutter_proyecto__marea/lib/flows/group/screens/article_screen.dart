import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/group_widgets.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 18, 24, 20),
              child: PageHeader(
                title: '¿Qué es la ansiedad generalizada?',
                subtitle: 'Publicado por el equipo de Marea',
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  children: const [
                    ArticleHeading('¿Qué es?'),
                    ArticleText(
                      'La ansiedad generalizada (TAG) es un trastorno caracterizado por una preocupación excesiva, persistente y difícil de controlar sobre aspectos cotidianos como la salud, el trabajo o la familia.',
                    ),
                    ArticleHeading('Características comunes'),
                    BulletText('La preocupación dura más de 6 meses.'),
                    BulletText(
                      'Afecta el rendimiento académico, laboral o personal.',
                    ),
                    BulletText('Puede surgir sin un motivo específico.'),
                    ArticleHeading('Síntomas frecuentes'),
                    BulletText('Inquietud constante o tensión'),
                    BulletText('Dificultad para concentrarse'),
                    BulletText('Fatiga o cansancio fácil'),
                    BulletText('Problemas para dormir'),
                    BulletText('Dolor de cabeza o molestias musculares'),
                    ArticleHeading('Causas posibles'),
                    BulletText('Genética (predisposición hereditaria)'),
                    BulletText('Experiencias traumáticas o estrés prolongado'),
                    BulletText(
                      'Factores neurobiológicos (desequilibrios químicos)',
                    ),
                    ArticleHeading('¿Cuándo debo buscar ayuda?'),
                    ArticleText(
                      'Si los síntomas interfieren con tu vida diaria y causan malestar continuo, es recomendable acudir con un profesional de salud mental.',
                    ),
                    ArticleHeading('Tratamientos comunes'),
                    BulletText('Terapia cognitivo-conductual (TCC)'),
                    BulletText('Mindfulness o meditación guiada'),
                    BulletText(
                      'Medicamentos, cuando son necesarios y bajo supervisión',
                    ),
                    ArticleHeading('Recomendación'),
                    ArticleText(
                      'Habla con un profesional si sospechas que tienes ansiedad generalizada. No estás solo.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
