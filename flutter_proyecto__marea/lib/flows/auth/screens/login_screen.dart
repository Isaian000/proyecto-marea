import 'package:flutter/material.dart';

import '../../../widgets/auth_footer_link.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/auth_scaffold.dart';
import '../../../widgets/marea_button.dart';
import '../../../widgets/marea_text_field.dart';
import '../../../widgets/remember_me_row.dart';
import '../../diario/screens/diary_shell_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: const AuthHeader(
        showLogo: true,
        title: 'Hola de nuevo',
        subtitle: 'Inicia sesión para seguir con tu diario.',
      ),
      body: Column(
        children: [
          MareaTextField(
            label: 'Correo electrónico',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          MareaTextField(
            label: 'Contraseña',
            controller: _password,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          RememberMeRow(
            value: _remember,
            onChanged: (v) => setState(() => _remember = v),
            onForgotPassword: () {},
          ),
          const SizedBox(height: 24),
          MareaButton(
            label: 'Iniciar sesión',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DiaryShellScreen()),
            ),
          ),
        ],
      ),
      footer: AuthFooterLink(
        text: '¿No tienes una cuenta?',
        actionLabel: 'Regístrate',
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
      ),
    );
  }
}
