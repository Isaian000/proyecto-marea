// widgets/common/marea_dropdown_field.dart
import 'package:flutter/material.dart';
import '../../core/app_text_styles.dart';

class MareaDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const MareaDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          style: AppTextStyles.input,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem<T>(value: e, child: Text('$e')))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}