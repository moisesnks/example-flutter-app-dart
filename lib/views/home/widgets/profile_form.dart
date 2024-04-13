import 'package:flutter/material.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/text.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final String email;
  final TextEditingController phoneController;
  final TextEditingController displayNameController;
  final TextEditingController photoUrlController;

  ProfileForm({
    required this.nameController,
    required this.email,
    required this.phoneController,
    required this.displayNameController,
    required this.photoUrlController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          labelText: 'Nombre',
          controller: nameController,
        ),
        CustomText(
          labelText: 'Correo electrónico',
          text: email,
        ),
        CustomTextField(
          labelText: 'Número de teléfono',
          controller: phoneController,
        ),
        CustomTextField(
          labelText: 'Nombre para mostrar',
          controller: displayNameController,
        ),
        CustomTextField(
          labelText: 'URL de la foto de perfil',
          controller: photoUrlController,
          isHidden: true,
        ),
      ],
    );
  }
}
