import 'package:flutter/material.dart';

import '../../../widgets/profile_widgets.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
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
    return ProfileFormScaffold(
      title: 'Información personal',
      child: Column(
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
                  options: const ['Mujer', 'Hombre', 'Otro'],
                  onChanged: (value) => setState(() => gender = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileLabeledDropdown(
                  label: 'País',
                  value: country,
                  options: const ['México', 'Colombia', 'Argentina'],
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
          const Spacer(),
          ProfileSaveButton(
            onPressed: () => saveAndReturn(context, 'Información guardada'),
          ),
        ],
      ),
    );
  }
}
