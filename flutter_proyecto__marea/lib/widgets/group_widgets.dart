import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../models/group_models.dart';
import 'community_widgets.dart';
import 'diary_widgets.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing = const SizedBox(),
  });
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            trailing,
          ],
        ),
        const SizedBox(height: 16),
        SerifText(title, size: 28, weight: FontWeight.bold),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: mutedColor(context), fontSize: 15),
        ),
      ],
    );
  }
}

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.size = 44,
  });
  final String initials;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        initials,
        style: const TextStyle(
          color: ink,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class IconAvatar extends StatelessWidget {
  const IconAvatar({
    super.key,
    required this.icon,
    required this.color,
    this.iconColor = cream,
    this.size = 44,
  });
  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}

class DarkTextField extends StatelessWidget {
  const DarkTextField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.prefixIcon,
  });
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: textColor(context)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: mutedColor(context)),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: mutedColor(context)),
        filled: true,
        fillColor: surfaceColor(context),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  const RatingCard({super.key, required this.onReviews});
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: gold, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4.78 de 5',
                  style: TextStyle(
                    color: ink,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Valoración del grupo',
                  style: TextStyle(color: grey, fontSize: 13),
                ),
              ],
            ),
          ),
          CardButton(label: 'Reseñas', filled: false, onPressed: onReviews),
        ],
      ),
    );
  }
}

class PolicyRow extends StatelessWidget {
  const PolicyRow({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ink, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: ink, fontSize: 14, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupOption extends StatelessWidget {
  const GroupOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: surfaceColor(context),
          foregroundColor: textColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: mutedColor(context)),
          ],
        ),
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  const ResourceCard({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });
  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: cream,
          foregroundColor: ink,
          padding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: grey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: grey),
          ],
        ),
      ),
    );
  }
}

class ArticleHeading extends StatelessWidget {
  const ArticleHeading(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: SerifText(text, color: ink, size: 18, weight: FontWeight.bold),
    );
  }
}

class ArticleText extends StatelessWidget {
  const ArticleText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: ink, fontSize: 15, height: 1.5),
    );
  }
}

class BulletText extends StatelessWidget {
  const BulletText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(color: ink, fontSize: 15)),
          Expanded(child: ArticleText(text)),
        ],
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({super.key, required this.topic, required this.onPressed});
  final Topic topic;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SerifText(topic.title, color: ink, size: 19, weight: FontWeight.bold),
          const SizedBox(height: 6),
          Text(
            '${topic.author} · ${topic.time}',
            style: const TextStyle(color: grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            topic.text,
            style: const TextStyle(color: ink, fontSize: 14, height: 1.45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${topic.replies} respuestas · ${topic.votes} votos',
                  style: const TextStyle(color: grey, fontSize: 13),
                ),
              ),
              CardButton(
                label: 'Ver discusión',
                filled: false,
                onPressed: onPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});
  final TopicComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InitialsAvatar(
            initials: comment.initials,
            color: comment.color,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.author,
                      style: TextStyle(
                        color: textColor(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.time,
                      style: TextStyle(
                        color: mutedColor(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: TextStyle(
                    color: textColor(context),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedProfileCard extends StatelessWidget {
  const SuggestedProfileCard({
    super.key,
    required this.name,
    required this.status,
    required this.initials,
    required this.color,
    required this.online,
    required this.onChat,
  });
  final String name;
  final String status;
  final String initials;
  final Color color;
  final bool online;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          InitialsAvatar(initials: initials, color: color, size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: ink,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(status, style: const TextStyle(color: grey, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: online ? teal : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: online ? teal : grey),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        online ? 'En línea' : 'Desconectado',
                        style: const TextStyle(color: grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CardButton(label: 'Chatear', filled: true, onPressed: onChat),
        ],
      ),
    );
  }
}

class GlobalChatCard extends StatelessWidget {
  const GlobalChatCard({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const IconAvatar(
                icon: Icons.chat_bubble_outline,
                color: teal,
                iconColor: ink,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chat global',
                      style: TextStyle(
                        color: textColor(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Únete a la conversación abierta del grupo',
                      style: TextStyle(
                        color: mutedColor(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor(context),
                side: BorderSide(color: mutedColor(context)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Entrar al chat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.showAuthor,
  });
  final ChatMessage message;
  final bool showAuthor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message.isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (showAuthor && message.author != '')
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              message.author,
              style: TextStyle(color: mutedColor(context), fontSize: 12),
            ),
          ),
        Container(
          constraints: const BoxConstraints(maxWidth: 260),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isMine ? teal : cream,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: ink, fontSize: 15, height: 1.35),
          ),
        ),
      ],
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.onSend,
  });
  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DarkTextField(hint: hint, controller: controller),
        ),
        const SizedBox(width: 10),
        IconButton.filled(
          onPressed: onSend,
          style: IconButton.styleFrom(
            backgroundColor: teal,
            foregroundColor: ink,
            minimumSize: const Size(52, 52),
          ),
          icon: const Icon(Icons.send_outlined),
        ),
      ],
    );
  }
}
