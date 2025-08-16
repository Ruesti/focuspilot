import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_outlined, size: 48, color: Colors.indigo),
            SizedBox(height: 8),
            Text('Home', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
