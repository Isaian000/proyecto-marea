import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../utils/account_validator.dart';
import '../../../widgets/profile_widgets.dart';

// Cambia el correo y la contraseña de la cuenta en Firebase Auth.
// El nombre se edita en "Información personal".
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final String _currentEmail = AuthService.currentUser?.email ?? '';
  late final emailController = TextEditingController(text: _currentEmail);
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final visible = [false, false, false];
  bool _saving = false;

  @override
  void dispose() {
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    final error = validateAccountChange(
      currentEmail: _currentEmail,
      newEmail: emailController.text,
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (error != null) {
      _showMessage(error);
      return;
    }

    final newEmail = emailController.text.trim();
    final changeEmail = emailWillChange(_currentEmail, newEmail);
    final changePassword = newPasswordController.text.isNotEmpty;

    setState(() => _saving = true);
    try {
      await AuthService.updateAccount(
        currentPassword: currentPasswordController.text,
        newEmail: changeEmail ? newEmail : null,
        newPassword: changePassword ? newPasswordController.text : null,
      );
      if (!mounted) return;
      final message = changeEmail
          ? 'Te enviamos un enlace a $newEmail. Tu correo cambiará cuando lo confirmes.'
          : 'Contraseña actualizada.';
      saveAndReturn(context, message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showMessage(AuthService.errorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Las cuentas de Google no tienen contraseña en Marea.
    final canEdit = AuthService.usesPassword;

    return ProfileFormScaffold(
      title: 'Correo y contraseña',
      button: ProfileSaveButton(onPressed: canEdit && !_saving ? _save : null),
      child: canEdit ? _form() : _googleNotice(),
    );
  }

  Widget _googleNotice() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        'Iniciaste sesión con Google. Tu correo y tu contraseña se '
        'administran desde tu cuenta de Google.',
        style: TextStyle(color: AppColors.ink, height: 1.5),
      ),
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileLabeledField(
          label: 'Correo electrónico',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 28),
        const Text(
          'Cambiar contraseña',
          style: TextStyle(
            color: AppColors.ink,
            fontFamily: 'Georgia',
            fontFamilyFallback: ['serif'],
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Déjala en blanco si solo quieres cambiar tu correo.',
          style: TextStyle(color: Color(0xFF777269), fontSize: 13),
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
        const SizedBox(height: 28),
        ProfilePasswordField(
          label: 'Contraseña actual (para confirmar los cambios)',
          controller: currentPasswordController,
          visible: visible[0],
          onToggle: () => setState(() => visible[0] = !visible[0]),
        ),
      ],
    );
  }
}
