import 'package:flutter/material.dart';

class PersonalityScreen extends StatelessWidget {
  const PersonalityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 48, color: Colors.indigo),
            SizedBox(height: 8),
            Text('Persönlichkeit', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
