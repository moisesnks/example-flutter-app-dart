import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/profile.dart';
import '../../../../viewmodels/profile_viewmodel.dart';
import 'profile_form.dart';
import 'profile_actions.dart';
import 'profile_image_widget.dart';
import 'dart:typed_data';

class ProfileWidget extends StatefulWidget {
  @override
  ProfileWidgetState createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _displayNameController;
  late TextEditingController _photoUrlController;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _displayNameController = TextEditingController();
    _photoUrlController = TextEditingController();

    Future.microtask(() {
      final profileViewModel =
          Provider.of<ProfileViewModel>(context, listen: false);
      if (profileViewModel.isAuthenticated) {
        _loadProfileData();
      }
    });
  }

  Future<void> _loadProfileData() async {
    await Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
    _updateTextControllers();
  }

  void _updateTextControllers() {
    final profile =
        Provider.of<ProfileViewModel>(context, listen: false).currentProfile;
    if (profile != null) {
      setState(() {
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _phoneController.text = profile.phoneNumber;
        _displayNameController.text = profile.displayName;
        _photoUrlController.text = profile.photoUrl ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _displayNameController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _logout() async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.logout();
  }

  Future<void> _saveChanges() async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final Profile updatedProfile = Profile(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      displayName: _displayNameController.text,
      photoUrl: _photoUrlController.text,
    );

    // Guardar cambios en el perfil
    await profileViewModel.submitProfileChanges(updatedProfile);

    // Después de guardar los cambios, recarga los datos del perfil desde el servidor
    await _loadProfileData();
  }

  void messageExito() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Imagen guardada y subida con éxito 🚀'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void onImageSelected(Uint8List imageBytes) async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    // Llama a la función para subir la foto de perfil
    await profileViewModel.uploadProfilePhoto(imageBytes);

    // Actualiza la URL de la imagen en el controlador de texto
    _photoUrlController.text = profileViewModel.currentProfile?.photoUrl ?? '';

    messageExito();

    _saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    if (!profileViewModel.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfileData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (profileViewModel.isLoading) CircularProgressIndicator(),
                if (!profileViewModel.isLoading) ...[
                  ProfileImageWidget(
                    image: _image,
                    imageUrl: profileViewModel.currentProfile?.photoUrl,
                    onImageSelected: onImageSelected,
                  ),
                  ProfileForm(
                    nameController: _nameController,
                    email: _emailController.text,
                    phoneController: _phoneController,
                    displayNameController: _displayNameController,
                    photoUrlController: _photoUrlController,
                  ),
                  ProfileActions(
                    onSave: _saveChanges,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
