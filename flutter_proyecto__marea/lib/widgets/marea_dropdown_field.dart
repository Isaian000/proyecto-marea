// widgets/common/marea_dropdown_field.dart
import 'package:flutter/material.dart';

import '../core/app_text_styles.dart';

class MareaDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const MareaDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  List<DropdownMenuItem<String>> _buildItems() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i = 0; i < items.length; i++) {
      menuItems.add(DropdownMenuItem(value: items[i], child: Text(items[i])));
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          style: AppTextStyles.input,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          items: _buildItems(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
