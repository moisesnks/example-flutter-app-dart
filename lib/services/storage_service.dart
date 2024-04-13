import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:mime/mime.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Función para eliminar todos los elementos en un directorio
  Future<void> deleteAllInDirectory(Reference directoryRef) async {
    // Lista todos los elementos en el directorio
    final ListResult listResult = await directoryRef.listAll();

    // Elimina todos los elementos en el directorio
    for (Reference item in listResult.items) {
      await item.delete();
    }

    // Elimina todos los subdirectorios
    for (Reference prefix in listResult.prefixes) {
      await deleteAllInDirectory(prefix);
    }
  }

  // Descargar la imagen de perfil del usuario
  Future<String?> downloadProfileImageUrl() async {
    // Obtén el UID del usuario autenticado
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('El usuario no está autenticado');
    }

    // Define la ruta de almacenamiento del archivo (raíz de users_profile)
    String filePath = 'users_profile/$userId';

    // Obtén la URL de descarga del archivo
    try {
      String filePath = 'users_profile/$userId';
      String url = await _storage.ref().child(filePath).getDownloadURL();
      return url;
    } catch (e) {
      throw Exception(
          'Error al obtener la URL de la imagen de perfil: $e \n $filePath');
    }
  }

  Future<String> uploadProfileImage(Uint8List imageBytes) async {
    // Obtén el UID del usuario autenticado
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('El usuario no está autenticado');
    }

    // Define la ruta de almacenamiento del directorio como `users_profile/$userId`
    String directoryPath = 'users_profile/$userId';

    // Primero, elimina todas las imágenes anteriores en el directorio
    await deleteAllInDirectory(_storage.ref().child(directoryPath));

    // Determina el tipo MIME y la extensión del archivo
    final mimeType = lookupMimeType('', headerBytes: imageBytes);
    final extension = mimeType != null ? mimeType.split('/').last : 'jpg';

    // Define la nueva ruta de almacenamiento del archivo como `users_profile/$userId/imgProfile.$extension`
    String filePath = '$directoryPath/imgProfile.$extension';

    try {
      // Subir el archivo a la nueva ruta
      await _storage
          .ref()
          .child(filePath)
          .putData(imageBytes, SettableMetadata(contentType: mimeType));

      // Obtener la URL de descarga del archivo
      String downloadURL =
          await _storage.ref().child(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Error al subir la imagen de perfil: $e');
    }
  }
}
