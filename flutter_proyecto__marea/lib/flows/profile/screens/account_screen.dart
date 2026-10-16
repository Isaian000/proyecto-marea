import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/profile_widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final nameController = TextEditingController(text: 'Elena Martin');
  final emailController = TextEditingController(
    text: 'elenamartin52@gmail.com',
  );
  final currentPasswordController = TextEditingController(text: '12345678');
  final newPasswordController = TextEditingController(text: '87654321');
  final confirmPasswordController = TextEditingController(text: '87654321');
  final visible = [false, false, false];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileFormScaffold(
      title: 'Correo y contraseña',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileLabeledField(label: 'Nombre', controller: nameController),
          const SizedBox(height: 14),
          ProfileLabeledField(
            label: 'Correo electrónico',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 28),
          const Text(
            'Restablecer contraseña',
            style: TextStyle(
              color: AppColors.ink,
              fontFamily: 'Georgia',
              fontFamilyFallback: ['serif'],
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ProfilePasswordField(
            label: 'Contraseña actual',
            controller: currentPasswordController,
            visible: visible[0],
            onToggle: () => setState(() => visible[0] = !visible[0]),
          ),
          const SizedBox(height: 14),
          ProfilePasswordField(
            label: 'Contraseña nueva',
            controller: newPasswordController,
            visible: visible[1],
            onToggle: () => setState(() => visible[1] = !visible[1]),
          ),
          const SizedBox(height: 14),
          ProfilePasswordField(
            label: 'Confirmar contraseña',
            controller: confirmPasswordController,
            visible: visible[2],
            onToggle: () => setState(() => visible[2] = !visible[2]),
          ),
          const Spacer(),
          ProfileSaveButton(
            onPressed: () {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Las contraseñas no coinciden')),
                );
                return;
              }
              saveAndReturn(context, 'Cuenta actualizada');
            },
          ),
        ],
      ),
    );
  }
}
