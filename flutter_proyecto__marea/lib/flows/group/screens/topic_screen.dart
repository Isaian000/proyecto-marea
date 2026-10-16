import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../models/group_models.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key, required this.topic});
  final Topic topic;

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<TopicComment> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments.addAll(widget.topic.comments);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _publish() {
    String text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _comments.add(
        TopicComment(
          author: 'elena_m',
          initials: 'EM',
          time: 'Ahora',
          text: text,
          color: gold,
        ),
      );
    });
    _controller.clear();
  }

  List<Widget> _buildComments() {
    List<Widget> items = [];
    for (int i = 0; i < _comments.length; i++) {
      items.add(CommentTile(comment: _comments[i]));
    }
    if (items.isEmpty) {
      items.add(
        Text(
          'Aún no hay comentarios. ¡Sé la primera persona en responder!',
          style: TextStyle(color: mutedColor(context)),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
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
                  SerifText(
                    widget.topic.title,
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.topic.author} · ${widget.topic.time}',
                    style: TextStyle(color: mutedColor(context), fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  CreamCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.topic.text,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 16,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${widget.topic.replies} respuestas · ${widget.topic.votes} votos',
                          style: const TextStyle(color: grey, fontSize: 13),
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
                  ..._buildComments(),
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
                    onPressed: _publish,
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
