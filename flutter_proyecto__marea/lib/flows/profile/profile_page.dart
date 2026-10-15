import 'package:flutter/material.dart';

const _navy = Color(0xFF1D2B33);
const _navyLight = Color(0xFF253943);
const _cream = Color(0xFFF5F1E8);
const _ink = Color(0xFF263037);
const _muted = Color(0xFFA8B7BA);
const _teal = Color(0xFF79B4A4);
const _gold = Color(0xFFE2A655);
const _blue = Color(0xFF647AA2);
const _orange = Color(0xFFF18458);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BackButton(),
              const SizedBox(height: 16),
              const _PageTitle('Mi perfil'),
              const SizedBox(height: 28),
              const CircleAvatar(
                radius: 48,
                backgroundColor: _gold,
                child: Text(
                  'EM',
                  style: TextStyle(
                    color: _ink,
                    fontFamily: 'Georgia',
                    fontFamilyFallback: ['serif'],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Elena Martin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _cream,
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['serif'],
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'elenamartin52@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 15),
              ),
              const SizedBox(height: 32),
              _ProfileOption(
                icon: Icons.person_outline,
                label: 'Información personal',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PersonalInformationPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ProfileOption(
                icon: Icons.lock_outline,
                label: 'Correo y contraseña',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountPage()),
                ),
              ),
              const SizedBox(height: 12),
              _ProfileOption(
                icon: Icons.info_outline,
                label: 'Nosotros',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _cream,
                  side: const BorderSide(color: Color(0xFF718087)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada')),
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final nameController = TextEditingController(text: 'Elena');
  final lastNameController = TextEditingController(text: 'Martin');
  final occupationController = TextEditingController(text: 'Barista');
  final addressController = TextEditingController();
  String gender = 'Mujer';
  String country = 'México';

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    occupationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Información personal',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Nombre',
                  controller: nameController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Apellido',
                  controller: lastNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _LabeledDropdown(
                  label: 'Género',
                  value: gender,
                  options: const ['Mujer', 'Hombre', 'Otro'],
                  onChanged: (value) => setState(() => gender = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledDropdown(
                  label: 'País',
                  value: country,
                  options: const ['México', 'Colombia', 'Argentina'],
                  onChanged: (value) => setState(() => country = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Ocupación (opcional)',
            controller: occupationController,
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Dirección (opcional)',
            controller: addressController,
            hint: 'Calle, número y colonia',
          ),
          const Spacer(),
          _SaveButton(
            onPressed: () => _saveAndReturn(context, 'Información guardada'),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
    return _FormScaffold(
      title: 'Correo y contraseña',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LabeledField(label: 'Nombre', controller: nameController),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Correo electrónico',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 28),
          const Text(
            'Restablecer contraseña',
            style: TextStyle(
              color: _ink,
              fontFamily: 'Georgia',
              fontFamilyFallback: ['serif'],
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _PasswordField(
            label: 'Contraseña actual',
            controller: currentPasswordController,
            visible: visible[0],
            onToggle: () => setState(() => visible[0] = !visible[0]),
          ),
          const SizedBox(height: 14),
          _PasswordField(
            label: 'Contraseña nueva',
            controller: newPasswordController,
            visible: visible[1],
            onToggle: () => setState(() => visible[1] = !visible[1]),
          ),
          const SizedBox(height: 14),
          _PasswordField(
            label: 'Confirmar contraseña',
            controller: confirmPasswordController,
            visible: visible[2],
            onToggle: () => setState(() => visible[2] = !visible[2]),
          ),
          const Spacer(),
          _SaveButton(
            onPressed: () {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Las contraseñas no coinciden')),
                );
                return;
              }
              _saveAndReturn(context, 'Cuenta actualizada');
            },
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BackButton(),
              const SizedBox(height: 16),
              const _PageTitle('Nosotros'),
              const SizedBox(height: 24),
              Container(
                width: 112,
                height: 40,
                padding: const EdgeInsets.all(7),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [_blue, Color(0xFFC7B48D), _orange],
                  ),
                ),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Marea',
                style: TextStyle(
                  color: _cream,
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['serif'],
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Un espacio para cuidar tu bienestar mental.',
                style: TextStyle(color: _muted, fontSize: 15),
              ),
              const SizedBox(height: 28),
              const _AboutSection(
                title: 'Nuestra misión',
                text: 'Acompañar a cada persona en su camino hacia el bienestar mental, ofreciendo espacios seguros, accesibles y empáticos donde pueda expresarse, aprender y sentirse apoyada.',
              ),
              const SizedBox(height: 26),
              const _AboutSection(
                title: 'Nuestra visión',
                text: 'Ser una comunidad digital referente en salud mental, donde el diálogo, la escucha activa y el cuidado emocional contribuyan a transformar vidas de manera positiva y consciente.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormScaffold extends StatelessWidget {
  const _FormScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: _BackButton(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: _PageTitle(title),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                decoration: const BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton.filled(
        style: IconButton.styleFrom(backgroundColor: _navyLight),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: _cream),
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _cream,
        fontFamily: 'Georgia',
        fontFamilyFallback: ['serif'],
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(17),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        decoration: BoxDecoration(
          color: _navyLight,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            Icon(icon, color: _cream, size: 21),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _cream,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: _muted),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
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
          style: const TextStyle(color: _ink),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
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
          style: const TextStyle(color: _ink),
          decoration: _inputDecoration(null).copyWith(
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

class _LabeledDropdown extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

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
          style: const TextStyle(color: _ink),
          decoration: _inputDecoration(null),
          items: options
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: _teal,
          foregroundColor: _ink,
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

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.title, required this.text});

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
            color: _cream,
            fontFamily: 'Georgia',
            fontFamilyFallback: ['serif'],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(color: _muted, height: 1.5)),
      ],
    );
  }
}

InputDecoration _inputDecoration(String? hint) {
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
      borderSide: const BorderSide(color: _teal, width: 2),
    ),
  );
}

void _saveAndReturn(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  Navigator.pop(context);
}
