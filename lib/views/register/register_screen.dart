import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/text_field.dart';
import '../../widgets/elevated_button.dart';
import '../../viewmodels/register_viewmodel.dart';

import '../../models/profile.dart';

import './styles.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registrationViewModel = Provider.of<RegistrationViewModel>(context);

    // Si el usuario ha iniciado sesión, posponer la navegación a `/home`
    if (registrationViewModel.isAuthenticated) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        title: Text(
          'Crear una cuenta',
          style: StylesRegister.titleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              controller: _nameController,
              labelText: 'Nombre',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              labelText: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Contraseña',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),
            if (registrationViewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              CustomElevatedButton(
                text: 'Registrarse',
                onPressed: () async {
                  final name = _nameController.text;
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  final profile = Profile(
                    name: name,
                    email: email,
                  );

                  await registrationViewModel.register(
                      email, password, profile);
                  if (registrationViewModel.errorMessage != null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(registrationViewModel.errorMessage!),
                        ),
                      );
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
