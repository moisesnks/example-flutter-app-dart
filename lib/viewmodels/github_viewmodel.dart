import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class GithubViewModel extends ChangeNotifier {
  final AuthService _authService;

  GithubViewModel(this._authService);

  String? _githubToken;
  List<dynamic>? _repos;
  List<dynamic>? _issues;

  // Método para obtener el token de acceso de GitHub del usuario autenticado
  Future<void> fetchGithubToken() async {
    _githubToken = await _authService.getGithubAccessToken();
  }

  // Método para obtener los repositorios del usuario
  Future<void> fetchRepos() async {
    // Asegúrate de obtener el token antes de realizar la solicitud
    await fetchGithubToken();
    if (_githubToken != null) {
      final response = await http.get(
        Uri.parse('https://api.github.com/user/repos'),
        headers: {
          'Authorization': 'Bearer $_githubToken',
        },
      );

      if (response.statusCode == 200) {
        _repos = json.decode(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch repositories');
      }
    } else {
      throw Exception('GitHub token not available');
    }
  }

  // Método para obtener los issues del usuario
  Future<void> fetchIssues() async {
    // Asegúrate de obtener el token antes de realizar la solicitud
    await fetchGithubToken();
    if (_githubToken != null) {
      final response = await http.get(
        Uri.parse('https://api.github.com/issues'),
        headers: {
          'Authorization': 'Bearer $_githubToken',
        },
      );

      if (response.statusCode == 200) {
        _issues = json.decode(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch issues');
      }
    } else {
      throw Exception('GitHub token not available');
    }
  }

  List<dynamic>? get repos => _repos;
  List<dynamic>? get issues => _issues;
}
