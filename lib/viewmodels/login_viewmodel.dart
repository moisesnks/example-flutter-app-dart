import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService; // Inyecta AuthService

  LoginViewModel(this._authService);

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
}
