import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_navigation.dart';
import 'screens/gpt_chat_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nmjnjoivqlvqnmkslhmj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tam5qb2l2cWx2cW5ta3NsaG1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxNTQ4NjQsImV4cCI6MjA2NTczMDg2NH0.oIM2iDjW1NgZO5LcnezgMDp6V1NpG7o92Ztv35hsFHw',
  );

  runApp(const ProviderScope(child: FocusPilotApp()));
}

class FocusPilotApp extends StatelessWidget {
  const FocusPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusPilot',
      debugShowCheckedModeBanner: false,

      // ✅ Windows: Maus/Trackpad darf "ziehen" wie Touch
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const _DesktopDragScrollBehavior(),
          child: child!,
        );
      },

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,

        // Soft/clay Hintergrund
        scaffoldBackgroundColor: const Color(0xFFF7F6FB),

        // ✅ FIX: CardThemeData statt CardTheme
        cardTheme: CardThemeData(
          color: Colors.white.withOpacity(0.92),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.black.withOpacity(0.06)),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6FB),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F1F2A),
          ),
          iconTheme: IconThemeData(color: Color(0xFF1F1F2A)),
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white.withOpacity(0.92),
          indicatorColor: Colors.indigo.withOpacity(0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ),

      home: const MainNavigation(),

      routes: {
        '/chat': (_) => const GPTChatPage(),
      },
    );
  }
}

class _DesktopDragScrollBehavior extends MaterialScrollBehavior {
  const _DesktopDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}
