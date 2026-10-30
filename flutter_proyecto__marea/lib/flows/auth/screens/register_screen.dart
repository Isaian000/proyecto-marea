import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../widgets/auth_footer_link.dart';
import '../../../widgets/auth_header.dart';
import '../../../widgets/auth_scaffold.dart';
import '../../../widgets/marea_button.dart';
import '../../../widgets/marea_dropdown_field.dart';
import '../../../widgets/marea_text_field.dart';
import 'register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _country;
  String? _gender;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _createAccount() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      _showMessage('Escribe tu nombre y tu correo.');
      return;
    }
    if (_password.text != _confirm.text) {
      _showMessage('Las contraseñas no coinciden.');
      return;
    }

    setState(() => _loading = true);
    try {
      // Crea el usuario en Firebase y le manda el correo de verificación.
      await AuthService.register(
        name: '${_name.text.trim()} ${_lastName.text.trim()}',
        email: _email.text,
        password: _password.text,
      );
    } catch (e) {
      if (mounted) {
        _showMessage(AuthService.errorMessage(e));
        setState(() => _loading = false);
      }
      return;
    }
    if (!mounted) return;

    NavigatorState navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute(builder: (_) => const RegisterSuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: AuthHeader(
        title: 'Crea tu cuenta',
        subtitle: 'Solo te tomará un minuto.',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MareaTextField(label: 'Nombre', controller: _name),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MareaTextField(label: 'Apellido', controller: _lastName),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MareaTextField(
            label: 'Correo electrónico',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MareaDropdownField(
                  label: 'País',
                  value: _country,
                  items: const ['México', 'Colombia', 'Argentina', 'España'],
                  onChanged: (v) => setState(() => _country = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MareaDropdownField(
                  label: 'Género',
                  value: _gender,
                  items: const [
                    'Mujer',
                    'Hombre',
                    'No binario',
                    'Prefiero no decir',
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MareaTextField(
            label: 'Contraseña',
            controller: _password,
            isPassword: true,
          ),
          const SizedBox(height: 14),
          MareaTextField(
            label: 'Confirmar contraseña',
            controller: _confirm,
            isPassword: true,
          ),
          const SizedBox(height: 24),
          MareaButton(
            label: _loading ? 'Creando cuenta...' : 'Crear cuenta',
            onPressed: _loading ? null : _createAccount,
          ),
        ],
      ),
      footer: AuthFooterLink(
        text: '¿Ya tienes cuenta?',
        actionLabel: 'Inicia sesión',
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}
