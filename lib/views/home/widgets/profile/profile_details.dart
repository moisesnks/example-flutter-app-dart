import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/profile_viewmodel.dart';
import '../../../../widgets/text_field.dart';
import '../../../../widgets/elevated_button.dart';
import '../../../../models/profile.dart';

class ProfileDetails extends StatefulWidget {
  @override
  ProfileDetailsState createState() => ProfileDetailsState();
}

class ProfileDetailsState extends State<ProfileDetails> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _displayNameController = TextEditingController();

    // Añade un listener que se activa cada vez que el modelo notifica a los listeners.
    Provider.of<ProfileViewModel>(context, listen: false)
        .addListener(_updateTextControllersOnProfileChange);
  }

  @override
  void dispose() {
    // Asegurarse de remover el listener cuando el widget se destruya.
    Provider.of<ProfileViewModel>(context, listen: false)
        .removeListener(_updateTextControllersOnProfileChange);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _updateTextControllersOnProfileChange() {
    Profile? profile =
        Provider.of<ProfileViewModel>(context, listen: false).currentProfile;
    if (profile != null) {
      _updateTextControllers(profile);
    }
  }

  void _updateTextControllers(Profile profile) {
    // Actualiza los controladores con información actual del perfil.
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _displayNameController.text = profile.displayName;
  }

  void _saveChanges() {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    Profile updatedProfile = Profile(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      displayName: _displayNameController.text,
      photoUrl: profileViewModel.currentProfile?.photoUrl,
    );
    profileViewModel.submitProfileChanges(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(labelText: 'Name', controller: _nameController),
        CustomTextField(labelText: 'Email', controller: _emailController),
        CustomTextField(
            labelText: 'Phone Number', controller: _phoneController),
        CustomTextField(
            labelText: 'Display Name', controller: _displayNameController),
        SizedBox(height: 20),
        CustomElevatedButton(text: 'Save Changes', onPressed: _saveChanges),
      ],
    );
  }
}
