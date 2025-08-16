import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projekte'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'GPT'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Einstellungen'),
        BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Abo'),
      ],
    );
  }
}
