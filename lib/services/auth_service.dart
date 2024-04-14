import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _githubAccessToken;

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

  // Método para iniciar sesión con GitHub
  Future<UserCredential> signInWithGithub() async {
    // Crea una instancia de GithubAuthProvider
    final GithubAuthProvider githubProvider = GithubAuthProvider();

    // Configura el ámbito de GitHub
    githubProvider.addScope('repo');
    githubProvider.addScope('read:user');

    try {
      final UserCredential userCredential =
          await _auth.signInWithPopup(githubProvider);

      // Obtiene el token de acceso de GitHub
      final credential = userCredential.credential as OAuthCredential?;

      // Asigna el token de acceso a _githubAccessToken
      _githubAccessToken = credential?.accessToken;

      return userCredential;
    } catch (e) {
      // Maneja cualquier error durante el inicio de sesión
      print('Error al iniciar sesión con GitHub: $e');
      rethrow;
    }
  }

  // Método para obtener el token de acceso de GitHub
  Future<String?> getGithubAccessToken() async {
    return _githubAccessToken; // Devuelve el token de acceso almacenado
  }
}
