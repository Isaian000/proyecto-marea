import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_header.dart';
import '../widgets/marea_text_field.dart';
import '../widgets/marea_dropdown_field.dart';
import '../widgets/marea_button.dart';
import '../widgets/auth_footer_link.dart';
import 'register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _country;
  String? _gender;

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
          const Row(
            children: [
              Expanded(child: MareaTextField(label: 'Nombre')),
              SizedBox(width: 12),
              Expanded(child: MareaTextField(label: 'Apellido')),
            ],
          ),
          const SizedBox(height: 14),
          const MareaTextField(
            label: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MareaDropdownField<String>(
                  label: 'País',
                  value: _country,
                  items: const ['México', 'Colombia', 'Argentina', 'España'],
                  onChanged: (v) => setState(() => _country = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MareaDropdownField<String>(
                  label: 'Género',
                  value: _gender,
                  items: const ['Mujer', 'Hombre', 'No binario', 'Prefiero no decir'],
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const MareaTextField(label: 'Contraseña', isPassword: true),
          const SizedBox(height: 14),
          const MareaTextField(label: 'Confirmar contraseña', isPassword: true),
          const SizedBox(height: 24),
          MareaButton(
            label: 'Crear cuenta',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (_) => const RegisterSuccessScreen()),
            ),
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