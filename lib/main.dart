import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/gpt_chat_page.dart'; // falls du diese Route nutzt
// import ... deine weiteren Importe

Future<void> _safeInit() async {
  // .env sicher laden (ohne Crash wenn Datei/Asset fehlt)
  try {
    // Tipp: wenn du die .env nicht als Asset eingetragen hast, nutze maybeLoad():
    //await dotenv.maybeLoad(); // lädt .env wenn vorhanden, sonst ignoriert
  } catch (e, st) {
    debugPrint('[FocusPilot] dotenv load error: $e\n$st');
  }

  // Supabase nur initialisieren, wenn Keys vorhanden
  final url = dotenv.env['SUPABASE_URL'];
  final anon = dotenv.env['SUPABASE_ANON_KEY'];

  if (url == null || url.isEmpty || anon == null || anon.isEmpty) {
    debugPrint('[FocusPilot] No Supabase keys found – starting offline.');
    return;
  }

  try {
    await Supabase.initialize(url: url, anonKey: anon);
  } catch (e, st) {
    debugPrint('[FocusPilot] Supabase init failed: $e\n$st');
    // NICHT rethrowen → App startet trotzdem
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fange frühe Flutter-Fehler ab (sonst nur "could not prepare isolate")
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('[FlutterError] ${details.exceptionAsString()}\n${details.stack}');
  };

  // Isolate-weit abfangen
  await _safeInit();

  runApp(const FocusPilotApp());
}

class FocusPilotApp extends StatelessWidget {
  const FocusPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusPilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const GPTChatPage(), // oder deine MainNavigation
      routes: {
        '/chat': (_) => const GPTChatPage(),
        // weitere Routen…
      },
    );
  }
}
