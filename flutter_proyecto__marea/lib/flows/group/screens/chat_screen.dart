import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../models/group_models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';
import '../group_navigation.dart';

// Chat en tiempo real: el general del grupo (withUid == null) o con una
// persona del grupo.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.title,
    required this.color,
    required this.hint,
    this.subtitle = '',
    this.initials = '',
    this.isGroup = false,
    this.withUid,
  });
  final String title;
  final Color color;
  final String hint;
  final String subtitle;
  final String initials;
  final bool isGroup;
  final String? withUid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late final Stream<List<ChatMessage>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = context.read<GroupProvider>().messages(withUid: widget.withUid);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    try {
      await context.read<GroupProvider>().sendMessage(
        text,
        withUid: widget.withUid,
      );
    } catch (e) {
      debugPrint('No se pudo enviar el mensaje: $e');
      if (mounted) {
        _controller.text = text;
        showGroupMessage(context, 'No se pudo enviar. Revisa tu conexión.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = widget.isGroup
        ? IconAvatar(icon: Icons.people_outline, color: widget.color)
        : InitialsAvatar(initials: widget.initials, color: widget.color);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  avatar,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: textColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (widget.subtitle != '')
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              color: mutedColor(context),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: surfaceColor(context)),
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: _messages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No se pudieron cargar los mensajes.',
                        style: TextStyle(color: mutedColor(context)),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!;
                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        'Envía el primer mensaje',
                        style: TextStyle(color: mutedColor(context)),
                      ),
                    );
                  }
                  // reverse: los mensajes nuevos quedan abajo y a la vista.
                  return ListView(
                    reverse: true,
                    padding: const EdgeInsets.all(20),
                    children: [
                      for (final message in messages.reversed)
                        MessageBubble(
                          message: message,
                          showAuthor: widget.isGroup && !message.isMine,
                        ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ChatInput(
                controller: _controller,
                hint: widget.hint,
                onSend: _send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
