import 'package:flutter/material.dart';

import '../core/app_text_styles.dart';

/// Etiqueta arriba + input blanco. Si isPassword, incluye el ojito.
class MareaTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const MareaTextField({
    super.key,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<MareaTextField> createState() => _MareaTextFieldState();
}

class _MareaTextFieldState extends State<MareaTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          style: AppTextStyles.input,
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
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
