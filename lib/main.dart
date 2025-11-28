import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_navigation.dart';
import 'screens/gpt_chat_page.dart'; // optional: Route /chat zeigt auf GPTChatPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nmjnjoivqlvqnmkslhmj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tam5qb2l2cWx2cW5ta3NsaG1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxNTQ4NjQsImV4cCI6MjA2NTczMDg2NH0.oIM2iDjW1NgZO5LcnezgMDp6V1NpG7o92Ztv35hsFHw',
  );

  runApp(
    const ProviderScope(
      child: FocusPilotApp(),
    ),
  );
}

class FocusPilotApp extends StatelessWidget {
  const FocusPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusPilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MainNavigation(),
      routes: {
        // Falls du irgendwo per Navigator.pushNamed(context, '/chat') gehst,
        // landet das jetzt in der GPTChatPage (Coach/Chat-Bereich).
        '/chat': (_) => const GPTChatPage(),
      },
    );
  }
}
