import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/profile_options.dart';
import '../../../models/app_user.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/profile_widgets.dart';

// Muestra y edita los datos del usuario guardados en Firestore (users/{uid}).
class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final occupationController = TextEditingController();
  final addressController = TextEditingController();
  String? gender;
  String? country;

  bool _filled = false;
  bool _saving = false;

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    occupationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Llena el formulario una sola vez, cuando ya llegaron los datos.
  void _fill(AppUser user) {
    nameController.text = user.nombre;
    lastNameController.text = user.apellido;
    occupationController.text = user.ocupacion ?? '';
    addressController.text = user.direccion ?? '';
    gender = kGenders.contains(user.genero) ? user.genero : null;
    country = kCountries.contains(user.pais) ? user.pais : null;
    _filled = true;
  }

  Future<void> _save() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Escribe tu nombre.')));
      return;
    }

    setState(() => _saving = true);
    try {
      await context.read<UserProvider>().updateProfile(
        nombre: nameController.text,
        apellido: lastNameController.text,
        genero: gender,
        pais: country,
        ocupacion: occupationController.text,
        direccion: addressController.text,
      );
      if (!mounted) return;
      saveAndReturn(context, 'Información guardada');
    } catch (e) {
      debugPrint('No se pudo guardar la información: $e');
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar. Revisa tu conexión.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    if (user != null && !_filled) _fill(user);

    return ProfileFormScaffold(
      title: 'Información personal',
      button: ProfileSaveButton(
        onPressed: _filled && !_saving ? _save : null,
      ),
      child: _filled
          ? _form()
          : Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: userProvider.error != null
                    ? Text(userProvider.error!)
                    : const CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileLabeledField(
                label: 'Nombre',
                controller: nameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileLabeledField(
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
              child: ProfileLabeledDropdown(
                label: 'Género',
                value: gender,
                options: kGenders,
                onChanged: (value) => setState(() => gender = value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileLabeledDropdown(
                label: 'País',
                value: country,
                options: kCountries,
                onChanged: (value) => setState(() => country = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ProfileLabeledField(
          label: 'Ocupación (opcional)',
          controller: occupationController,
        ),
        const SizedBox(height: 14),
        ProfileLabeledField(
          label: 'Dirección (opcional)',
          controller: addressController,
          hint: 'Calle, número y colonia',
        ),
      ],
    );
  }
}
