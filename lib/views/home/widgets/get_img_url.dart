import 'package:http/http.dart' as http;

Future<String?> getImgUrl(String imgUrl) async {
  try {
    // Realizamos una solicitud HEAD para verificar si la imagen está disponible
    final response = await http.head(Uri.parse(imgUrl));
    if (response.statusCode == 200) {
      print("The image exists!");
      return imgUrl;
    } else {
      print("Image not found: ${response.statusCode}");
      return null; // Retorna null si la imagen no se puede cargar
    }
  } catch (e) {
    // Aquí podemos decidir no imprimir el error si es un error común esperado
    if (e is http.ClientException) {
      print("HTTP request failed silently: $e");
    } else {
      // Otros errores pueden necesitar ser registrados o manejados de otra manera
      print("Unexpected error: $e");
    }
    return null;
  }
}
