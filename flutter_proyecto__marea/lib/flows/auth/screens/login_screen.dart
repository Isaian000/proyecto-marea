import 'package:flutter/material.dart';

import '../../../core/app_text_styles.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/auth_footer_link.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/auth_scaffold.dart';
import '../../../widgets/google_sign_in_button.dart';
import '../../../widgets/marea_button.dart';
import '../../../widgets/marea_text_field.dart';
import '../../../widgets/remember_me_row.dart';
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
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Al entrar, el AuthGate cambia solo a la pantalla del diario.
  Future<void> _run(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
    } catch (e) {
      if (mounted) _showMessage(AuthService.errorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _signIn() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _showMessage('Escribe tu correo y tu contraseña.');
      return;
    }
    _run(() => AuthService.signIn(_email.text, _password.text));
  }

  void _signInWithGoogle() {
    _run(() async {
      await AuthService.signInWithGoogle();
    });
  }

  void _forgotPassword() {
    if (_email.text.trim().isEmpty) {
      _showMessage('Escribe tu correo para enviarte el enlace.');
      return;
    }
    _run(() async {
      await AuthService.sendPasswordReset(_email.text);
      if (mounted) {
        _showMessage('Te enviamos un correo para cambiar tu contraseña.');
      }
    });
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
            onForgotPassword: _loading ? () {} : _forgotPassword,
          ),
          const SizedBox(height: 24),
          MareaButton(
            label: _loading ? 'Entrando...' : 'Iniciar sesión',
            onPressed: _loading ? null : _signIn,
          ),
          const SizedBox(height: 14),
          Text('o', style: AppTextStyles.small),
          const SizedBox(height: 14),
          GoogleSignInButton(onPressed: _loading ? null : _signInWithGoogle),
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
