import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/group_models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';
import '../group_navigation.dart';

// Un tema con sus comentarios en tiempo real desde Firestore.
class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key, required this.topicId});
  final String topicId;

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final TextEditingController _controller = TextEditingController();
  late final Stream<List<TopicComment>> _comments;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _comments = context.read<GroupProvider>().comments(widget.topicId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _publish(Topic topic) async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await context.read<GroupProvider>().addComment(topic, text);
      _controller.clear();
    } catch (e) {
      debugPrint('No se pudo publicar el comentario: $e');
      if (mounted) {
        showGroupMessage(context, 'No se pudo publicar. Revisa tu conexión.');
      }
    }
    if (mounted) setState(() => _sending = false);
  }

  Future<void> _vote(Topic topic) async {
    try {
      await context.read<GroupProvider>().toggleVote(topic);
    } catch (e) {
      debugPrint('No se pudo votar: $e');
      if (mounted) showGroupMessage(context, 'No se pudo guardar tu voto.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final topic = provider.topicById(widget.topicId);
    if (topic == null) {
      return const Scaffold(body: Center(child: Text('Este tema ya no existe')));
    }
    final voted = topic.votedBy(provider.uid);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RoundIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SerifText(topic.title, size: 24, weight: FontWeight.bold),
                  const SizedBox(height: 6),
                  Text(
                    '${topic.author} · ${topic.time}',
                    style: TextStyle(color: mutedColor(context), fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  CreamCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.text,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 16,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${topic.replies} respuestas · ${topic.votes} votos',
                                style: const TextStyle(
                                  color: grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _vote(topic),
                              icon: Icon(
                                voted ? Icons.favorite : Icons.favorite_border,
                                color: voted ? orange : grey,
                                size: 18,
                              ),
                              label: Text(
                                voted ? 'Votaste' : 'Votar',
                                style: const TextStyle(color: ink),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Comentarios',
                    style: TextStyle(color: mutedColor(context), fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  StreamBuilder<List<TopicComment>>(
                    stream: _comments,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'No se pudieron cargar los comentarios.',
                          style: TextStyle(color: mutedColor(context)),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final comments = snapshot.data!;
                      if (comments.isEmpty) {
                        return Text(
                          'Aún no hay comentarios. ¡Sé la primera persona en responder!',
                          style: TextStyle(color: mutedColor(context)),
                        );
                      }
                      return Column(
                        children: [
                          for (final comment in comments)
                            CommentTile(comment: comment),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(height: 1, color: surfaceColor(context)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DarkTextField(
                      hint: 'Únete a la conversación',
                      controller: _controller,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _sending ? null : () => _publish(topic),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: ink,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Publicar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
