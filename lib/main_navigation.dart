import 'package:flutter/material.dart';
import 'package:focuspilot/screens/subscription_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_page.dart';
import 'screens/home_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/coach_chat_page.dart';      // 👈 NEU
import 'screens/personality_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProjectsScreen(),
    CoachChatPage(),      // 👈 GPT-Tab = reiner Coaching-Bereich
    PersonalityScreen(),
    SettingsScreen(),
    SubscriptionPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const LoginPage();
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
