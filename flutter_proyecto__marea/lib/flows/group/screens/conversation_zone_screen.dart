import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';
import '../group_navigation.dart';
import 'topic_screen.dart';

// Temas del grupo desde Firestore. Se puede abrir un tema nuevo.
class ConversationZoneScreen extends StatelessWidget {
  const ConversationZoneScreen({super.key});

  Future<void> _newTopic(BuildContext context) async {
    final provider = context.read<GroupProvider>();
    final result = await showDialog<({String title, String text})>(
      context: context,
      builder: (_) => const _NewTopicDialog(),
    );
    if (result == null || !context.mounted) return;
    final title = result.title;
    final text = result.text;
    if (title.isEmpty || text.isEmpty) {
      showGroupMessage(context, 'Escribe un título y un mensaje.');
      return;
    }
    try {
      await provider.createTopic(title: title, text: text);
      if (context.mounted) showGroupMessage(context, 'Tema publicado');
    } catch (e) {
      debugPrint('No se pudo publicar el tema: $e');
      if (context.mounted) {
        showGroupMessage(context, 'No se pudo publicar. Revisa tu conexión.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final topics = provider.topics;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            children: [
              const PageHeader(
                title: 'Zona de conversación',
                subtitle: 'Temas abiertos del grupo',
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Abrir un tema',
                onPressed: () => _newTopic(context),
              ),
              const SizedBox(height: 20),
              if (provider.loading && topics.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (topics.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    provider.error ??
                        'Aún no hay temas. Abre el primero para empezar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mutedColor(context)),
                  ),
                )
              else
                for (final topic in topics)
                  TopicCard(
                    topic: topic,
                    onPressed: () =>
                        pushInGroup(context, TopicScreen(topicId: topic.id)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// Diálogo para abrir un tema. Maneja sus propios campos de texto y los
// libera cuando el diálogo ya se cerró por completo.
class _NewTopicDialog extends StatefulWidget {
  const _NewTopicDialog();

  @override
  State<_NewTopicDialog> createState() => _NewTopicDialogState();
}

class _NewTopicDialogState extends State<_NewTopicDialog> {
  final _title = TextEditingController();
  final _text = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo tema'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: '¿Qué quieres compartir?',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, (
            title: _title.text.trim(),
            text: _text.text.trim(),
          )),
          child: const Text('Publicar'),
        ),
      ],
    );
  }
}
