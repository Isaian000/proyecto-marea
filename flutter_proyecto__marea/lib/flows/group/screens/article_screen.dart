import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/group_models.dart';
import '../../../widgets/group_widgets.dart';

// Muestra un recurso del grupo. El texto viene de Firestore con líneas
// sencillas: "## Título", "- viñeta" o un párrafo normal.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.resource});
  final GroupResource resource;

  List<Widget> _buildBody() {
    final widgets = <Widget>[];
    for (final raw in resource.body.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('## ')) {
        widgets.add(ArticleHeading(line.substring(3)));
      } else if (line.startsWith('- ')) {
        widgets.add(BulletText(line.substring(2)));
      } else {
        widgets.add(ArticleText(line));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
              child: PageHeader(
                title: resource.title,
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
                  children: _buildBody(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
