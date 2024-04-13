import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/github_viewmodel.dart';

class GithubWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Acceder al GithubViewModel desde el provider
    final githubViewModel = Provider.of<GithubViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón para cargar repositorios
        ElevatedButton(
          onPressed: () {
            // Llamar al método para cargar repositorios
            githubViewModel.fetchRepos();
          },
          child: Text('Cargar Repositorios'),
        ),
        // Lista de repositorios
        Expanded(
          child: ListView.builder(
            itemCount: githubViewModel.repos?.length ?? 0,
            itemBuilder: (context, index) {
              final repo = githubViewModel.repos?[index];
              return ListTile(
                title: Text(repo['name']),
                subtitle: Text(repo['description'] ?? 'Sin descripción'),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        // Botón para cargar issues
        ElevatedButton(
          onPressed: () {
            // Llamar al método para cargar issues
            githubViewModel.fetchIssues();
          },
          child: Text('Cargar Issues'),
        ),
        // Lista de issues
        Expanded(
          child: ListView.builder(
            itemCount: githubViewModel.issues?.length ?? 0,
            itemBuilder: (context, index) {
              final issue = githubViewModel.issues?[index];
              return ListTile(
                title: Text(issue['title']),
                subtitle: Text('Estado: ${issue['state']}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
