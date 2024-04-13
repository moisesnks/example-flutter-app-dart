import 'package:flutter/material.dart';
import '../../../widgets/elevated_button.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onSave;

  ProfileActions({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        CustomElevatedButton(
          text: 'Guardar cambios',
          onPressed: onSave,
        ),
      ],
    );
  }
}
