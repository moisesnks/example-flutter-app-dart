import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtiene el usuario actual
  User? get currentUser => _auth.currentUser;

  // Verifica si el usuario está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  // Iniciar sesión
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Registrar un nuevo usuario
  Future<UserCredential> registerUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Actualizar el perfil del usuario
  Future<void> updateUserProfile(
      {String? displayName, String? photoUrl}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoUrl);
      await user
          .reload(); // Recargar el usuario para obtener los datos actualizados
    }
  }
}
