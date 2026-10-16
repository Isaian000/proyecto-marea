import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? teal : surfaceColor(context),
        foregroundColor: selected ? ink : textColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// circulo de color con icono de chat
class ChatCircle extends StatelessWidget {
  const ChatCircle({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const Icon(Icons.chat_bubble_outline, color: cream, size: 20),
    );
  }
}

// etiqueta publico o privado
class PrivacyLabel extends StatelessWidget {
  const PrivacyLabel({super.key, required this.isPublic});
  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isPublic ? Icons.public : Icons.lock_outline,
          size: 16,
          color: grey,
        ),
        const SizedBox(width: 6),
        Text(
          isPublic ? 'Público' : 'Privado',
          style: const TextStyle(color: grey, fontSize: 13),
        ),
      ],
    );
  }
}

// boton de tarjeta relleno o con borde
class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onPressed,
  });
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
    if (filled) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: ink,
          elevation: 0,
        ),
        child: Text(label, style: textStyle),
      );
    }
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: ink,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        side: const BorderSide(color: grey),
      ),
      child: Text(label, style: textStyle),
    );
  }
}

// tarjeta de foro
class ForumCard extends StatelessWidget {
  const ForumCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isPublic,
    required this.onPressed,
  });
  final String title;
  final String subtitle;
  final Color color;
  final bool isPublic;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ChatCircle(color: color),
              const SizedBox(width: 14),
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: PrivacyLabel(isPublic: isPublic)),
              CardButton(
                label: isPublic ? 'Unirse' : 'Mandar solicitud',
                filled: isPublic,
                onPressed: onPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// tarjeta de grupo
class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.name,
    required this.members,
    required this.color,
    required this.isPublic,
    required this.onPressed,
  });
  final String name;
  final String members;
  final Color color;
  final bool isPublic;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ChatCircle(color: color),
              const SizedBox(width: 14),
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
                    const SizedBox(height: 4),
                    Text(
                      members,
                      style: const TextStyle(color: grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: PrivacyLabel(isPublic: isPublic)),
              CardButton(label: 'Entrar', filled: true, onPressed: onPressed),
            ],
          ),
        ],
      ),
    );
  }
}

// arte de las pantallas hablemos de

class ForumIntroArt extends StatelessWidget {
  const ForumIntroArt({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surfaceColor(context),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -90,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -35,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .22),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: cream,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// registro exitoso
