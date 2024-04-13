import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/profile.dart';

class RegistrationViewModel extends ChangeNotifier {
  final AuthService _authService; // Inyecta AuthService
  final FirestoreService _firestoreService; // Inyecta FirestoreService

  RegistrationViewModel(this._authService, this._firestoreService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.isAuthenticated;

  Future<void> register(String email, String password, Profile profile) async {
    if (_authService.isAuthenticated) {
      _errorMessage =
          "Already signed in. Please sign out before registering a new account.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Registrar al usuario en Firebase
      await _authService.registerUser(email, password);
      // Después de registrar al usuario, guarda el perfil del usuario en Firestore
      await _firestoreService.registerProfile(profile);
      // Limpiar mensaje de error en caso de éxito
      _errorMessage = null;
    } catch (e) {
      _handleFirebaseAuthException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleFirebaseAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'El correo ya está en uso';
          break;
        case 'weak-password':
          _errorMessage = 'Contraseña débil';
          break;
        default:
          _errorMessage =
              'Error al registrar usuario: [${e.code}] ${e.message}';
      }
    } else {
      _errorMessage = 'Error desconocido: $e';
    }
    notifyListeners();
  }
}
