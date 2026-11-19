import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../models/group_summary.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';
import '../group_navigation.dart';
import 'conversation_zone_screen.dart';
import 'interaction_zone_screen.dart';
import 'resources_screen.dart';

// Portada de un grupo. Crea el GroupProvider que usan sus pantallas.
class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key, required this.group});
  final GroupSummary group;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupProvider(group: group)..load(),
      child: const _GroupView(),
    );
  }
}

class _GroupView extends StatelessWidget {
  const _GroupView();

  Future<void> _rate(BuildContext context) async {
    final provider = context.read<GroupProvider>();
    var rating = provider.reviews.myRating ?? 0;
    final chosen = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Califica el grupo'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: '$i',
                  onPressed: () => setDialogState(() => rating = i),
                  icon: Icon(
                    i <= rating ? Icons.star : Icons.star_border,
                    color: gold,
                    size: 32,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: rating == 0
                  ? null
                  : () => Navigator.pop(dialogContext, rating),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (chosen == null || !context.mounted) return;
    try {
      await provider.rate(chosen);
      if (context.mounted) showGroupMessage(context, 'Gracias por tu reseña');
    } catch (e) {
      debugPrint('No se pudo guardar la reseña: $e');
      if (context.mounted) {
        showGroupMessage(context, 'No se pudo guardar. Revisa tu conexión.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final group = provider.group;
    final members = provider.memberCount;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            children: [
              PageHeader(
                title: group.name,
                subtitle: members == 0
                    ? group.membersLabel
                    : members == 1
                    ? '1 integrante'
                    : '$members integrantes',
                trailing: IconAvatar(
                  icon: Icons.people_outline,
                  color: group.color,
                ),
              ),
              const SizedBox(height: 20),
              RatingCard(
                summary: provider.reviews,
                onReviews: () => _rate(context),
              ),
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
                    const SerifText(
                      'Políticas del grupo',
                      color: ink,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 14),
                    const PolicyRow(
                      icon: Icons.chat_bubble_outline,
                      text:
                          'Respeto mutuo: todos los comentarios deben ser empáticos.',
                    ),
                    const PolicyRow(
                      icon: Icons.check,
                      text:
                          'Sin juicios: este es un espacio libre de críticas o burlas.',
                    ),
                    const PolicyRow(
                      icon: Icons.lock_outline,
                      text:
                          'Confidencialidad: lo que se dice aquí, se queda aquí.',
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: const Color(0xFFDDD5C7),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nivel de actividad',
                      style: TextStyle(
                        color: ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      provider.loading && provider.topics.isEmpty
                          ? 'Cargando...'
                          : '${provider.topics.length} temas abiertos y '
                                '${provider.resources.length} recursos para leer.',
                      style: const TextStyle(
                        color: grey,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  provider.error!,
                  style: const TextStyle(color: orange),
                ),
              ],
              const SizedBox(height: 16),
              GroupOption(
                icon: Icons.menu_book_outlined,
                label: 'Recursos útiles',
                onPressed: () => pushInGroup(context, const ResourcesScreen()),
              ),
              GroupOption(
                icon: Icons.chat_bubble_outline,
                label: 'Zona de conversación',
                onPressed: () =>
                    pushInGroup(context, const ConversationZoneScreen()),
              ),
              GroupOption(
                icon: Icons.people_outline,
                label: 'Zona de interacción',
                onPressed: () =>
                    pushInGroup(context, const InteractionZoneScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
