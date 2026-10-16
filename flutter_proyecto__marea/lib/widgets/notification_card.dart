import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class NotificationSectionTitle extends StatelessWidget {
  const NotificationSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.muted, fontSize: 13),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.unread = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE7E1D2),
            child: Icon(icon, color: AppColors.ink, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF777269),
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (unread)
            const Padding(
              padding: EdgeInsets.only(top: 1),
              child: CircleAvatar(radius: 4, backgroundColor: AppColors.orange),
            ),
        ],
      ),
    );
  }
}
