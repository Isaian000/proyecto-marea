import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(color: mutedColor(context), fontSize: 13),
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor(context),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor(context), size: 21),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: mutedColor(context), fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeTrackColor: teal),
        ],
      ),
    );
  }
}
