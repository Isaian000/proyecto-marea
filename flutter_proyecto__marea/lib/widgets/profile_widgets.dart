import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import 'diary_widgets.dart';

class ProfileFormScaffold extends StatelessWidget {
  const ProfileFormScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.button,
  });

  final String title;
  final Widget child;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: ProfileBackButton(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: ProfileScreenTitle(title),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                // LOS CAMPOS HACEN SCROLL CON EL TECLADO ABIERTO Y EL BOTON
                // DE GUARDAR SE QUEDA FIJO ABAJO
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: ListView(children: [child])),
                    const SizedBox(height: 16),
                    button,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileBackButton extends StatelessWidget {
  const ProfileBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RoundIconButton(
        icon: Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class ProfileScreenTitle extends StatelessWidget {
  const ProfileScreenTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Georgia',
        fontFamilyFallback: ['serif'],
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  const ProfileOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: surfaceColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor(context), size: 21),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: textColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: mutedColor(context)),
        ],
      ),
    );
  }
}

class ProfileLabeledField extends StatelessWidget {
  const ProfileLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF777269))),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.ink),
          decoration: profileInputDecoration(hint),
        ),
      ],
    );
  }
}

class ProfilePasswordField extends StatelessWidget {
  const ProfilePasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.visible,
    required this.onToggle,
  });

  final String label;
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF777269))),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: !visible,
          style: const TextStyle(color: AppColors.ink),
          decoration: profileInputDecoration(null).copyWith(
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                visible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF777269),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileLabeledDropdown extends StatelessWidget {
  const ProfileLabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  List<DropdownMenuItem<String>> _buildItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < options.length; i++) {
      items.add(DropdownMenuItem(value: options[i], child: Text(options[i])));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF777269))),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(color: AppColors.ink),
          decoration: profileInputDecoration(null),
          items: _buildItems(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ],
    );
  }
}

class ProfileSaveButton extends StatelessWidget {
  const ProfileSaveButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          'Guardar cambios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ProfileAboutSection extends StatelessWidget {
  const ProfileAboutSection({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontFamilyFallback: ['serif'],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(text, style: TextStyle(color: mutedColor(context), height: 1.5)),
      ],
    );
  }
}

InputDecoration profileInputDecoration(String? hint) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFDDD5C7)),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF8B877F)),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.teal, width: 2),
    ),
  );
}

void saveAndReturn(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  Navigator.pop(context);
}

void logOut(BuildContext context, int screensToClose) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
  for (int i = 0; i < screensToClose; i++) {
    Navigator.pop(context);
  }
}
