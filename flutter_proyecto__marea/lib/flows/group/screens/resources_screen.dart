import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/group_widgets.dart';
import '../group_navigation.dart';
import 'article_screen.dart';

// Lecturas del grupo desde Firestore, con buscador.
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final query = _query.toLowerCase();
    final shown = provider.resources
        .where(
          (r) =>
              r.title.toLowerCase().contains(query) ||
              r.description.toLowerCase().contains(query),
        )
        .toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            children: [
              PageHeader(
                title: 'Recursos útiles',
                subtitle: 'Lecturas breves del grupo de ${provider.group.topic}',
              ),
              const SizedBox(height: 18),
              DarkTextField(
                hint: 'Buscar',
                prefixIcon: Icons.search,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 16),
              if (provider.loading && provider.resources.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (shown.isEmpty)
                Text(
                  provider.error ?? 'No encontramos recursos con esa búsqueda.',
                  style: TextStyle(color: mutedColor(context)),
                )
              else
                for (final resource in shown)
                  ResourceCard(
                    title: resource.title,
                    description: resource.description,
                    onPressed: () => pushInGroup(
                      context,
                      ArticleScreen(resource: resource),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
