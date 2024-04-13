import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/profile.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  LoginViewModel(this._authService, this._firestoreService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _authService.isAuthenticated;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    if (_authService.isAuthenticated) {
      _errorMessage = 'Ya has iniciado sesión.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _authService.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  Future<void> signInWithGithub() async {
    try {
      // Autenticar al usuario con GitHub
      UserCredential userCredential = await _authService.signInWithGithub();

      // Obtener información del usuario de GitHub
      User user = userCredential.user!;
      String? displayName = user.displayName;
      String? photoUrl = user.photoURL;

      print("Usuario autenticado con GitHub: $user");

      // Obtener la dirección de correo electrónico desde providerData
      String? email;
      for (UserInfo info in user.providerData) {
        if (info.providerId == 'github.com') {
          email = info.email;
          break;
        }
      }

      // Verificar que se encontró una dirección de correo electrónico
      if (email == null) {
        _errorMessage =
            'No se pudo obtener una dirección de correo electrónico del proveedor de GitHub.';
        notifyListeners();
        return;
      }

      // Crear un perfil de usuario con la información obtenida
      Profile profile = Profile(
        name: displayName!,
        displayName: displayName,
        photoUrl: photoUrl,
        email: email,
      );

      // Guardar la información del usuario en Firestore
      print("Intentando registrar perfil... $profile");
      try {
        await _firestoreService.registerProfile(profile);
        print('Perfil registrado');
      } catch (e) {
        print("Error al registrar el perfil: $e");
        throw Exception('Error al registrar el perfil: $e');
      }

      notifyListeners();
    } catch (e) {
      // Manejar cualquier error durante el proceso
      _errorMessage = 'Error al iniciar sesión con GitHub: $e';
      notifyListeners();
    }
  }
}
