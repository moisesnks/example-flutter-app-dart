import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'styles.dart';
import '../../widgets/text_field.dart';
import '../../widgets/elevated_button.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    // Si el usuario ha iniciado sesión, posponer la navegación a `/home`
    if (loginViewModel.isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bienvenido', style: Styles.titleStyle),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                labelText: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              if (loginViewModel.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                CustomElevatedButton(
                  text: 'Iniciar sesión',
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    loginViewModel.login(email, password);
                    if (loginViewModel.errorMessage != null) {
                      // Mostrar SnackBar con el mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(loginViewModel.errorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              const SizedBox(height: 20),
              // Botón para iniciar sesión con GitHub
              CustomElevatedButton(
                text: 'Iniciar sesión con GitHub',
                onPressed: () {
                  loginViewModel.signInWithGithub();
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navegar a RegisterScreen cuando se hace clic
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  '¿No tienes una cuenta aún? Regístrate',
                  style: Styles.linkStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
