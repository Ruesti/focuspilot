import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open, size: 48, color: Colors.indigo),
            SizedBox(height: 8),
            Text('Projekte', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
