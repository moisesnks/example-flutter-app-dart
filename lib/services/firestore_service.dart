import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrar datos de un perfil de usuario cuando se registra
  Future<void> registerProfile(Profile profile) async {
    // Obtener el UID actual
    String? userId = _auth.currentUser?.uid;

    // Crear un documento con el UID del usuario
    try {
      await _firestore
          .collection('USERS')
          .doc(userId)
          .set(profile.toFirestore());
    } catch (e) {
      throw Exception('Error al registrar el perfil: $e');
    }
  }

  // Actualizar datos de un perfil de usuario
  Future<void> updateProfile(Profile profile) async {
    // Obtener el UID actual
    String? userId = _auth.currentUser?.uid;

    // Actualizar el documento con el UID del usuario
    try {
      await _firestore
          .collection('USERS')
          .doc(userId)
          .update(profile.toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar el perfil: $e');
    }
  }

  // Obtener datos de un perfil de usuario
  Future<Profile> getProfile() async {
    String? userId = _auth.currentUser?.uid;

    // Obtener el documento con el UID del usuario
    try {
      final DocumentSnapshot document =
          await _firestore.collection('USERS').doc(userId).get();
      return Profile.fromFirestore(document.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al obtener el perfil: $e');
    }
  }

  // Eliminar datos de un perfil de usuario siendo admin,
  // este sólo lo usará el admin en su UI por si necesita eliminar a alguien
  Future<void> deleteProfile(String userId) async {
    // Eliminar el documento con el UID del usuario
    // prevenir un suicido
    if (userId == _auth.currentUser?.uid) {
      throw Exception('No puedes eliminar tu propio perfil');
    }
    try {
      await _firestore.collection('USERS').doc(userId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el perfil: $e');
    }
  }
}
