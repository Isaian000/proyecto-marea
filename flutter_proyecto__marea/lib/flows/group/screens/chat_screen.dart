import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

import '../../../models/group_models.dart';
import '../../../widgets/diary_widgets.dart';
import '../../../widgets/group_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.title,
    required this.color,
    required this.hint,
    this.subtitle = '',
    this.initials = '',
    this.isGroup = false,
    this.messages = const [],
  });
  final String title;
  final Color color;
  final String hint;
  final String subtitle;
  final String initials;
  final bool isGroup;
  final List<ChatMessage> messages;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll(widget.messages);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    String text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(ChatMessage(text: text, isMine: true, author: 'Tú'));
    });
    _controller.clear();
  }

  List<Widget> _buildMessages() {
    List<Widget> items = [];
    for (int i = 0; i < _messages.length; i++) {
      items.add(
        MessageBubble(message: _messages[i], showAuthor: widget.isGroup),
      );
    }
    if (items.isEmpty) {
      items.add(
        Center(
          child: Text(
            'Envía el primer mensaje',
            style: TextStyle(color: mutedColor(context)),
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (widget.isGroup) {
      avatar = IconAvatar(icon: Icons.people_outline, color: widget.color);
    } else {
      avatar = InitialsAvatar(initials: widget.initials, color: widget.color);
    }

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
                  if (!widget.isGroup)
                    const RoundIconButton(icon: Icons.phone_outlined),
                  const SizedBox(width: 6),
                  const RoundIconButton(icon: Icons.more_vert),
                ],
              ),
            ),
            Divider(height: 1, color: surfaceColor(context)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: _buildMessages(),
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
