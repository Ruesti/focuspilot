import 'package:flutter/material.dart';
import 'package:focuspilot/main_navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Zielseite nach Login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  String? errorMessage;
  bool isLoading = false;

Future<void> handleAuth() async {
  setState(() {
    isLoading = true;
  });

  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  try {
    final client = Supabase.instance.client;

    if (isLogin) {
      await client.auth.signInWithPassword(email: email, password: password);
    } else {
      final res = await client.auth.signUp(email: email, password: password);

      // ⚠️ Registrierung war nicht erfolgreich
      if (res.user == null) {
        throw AuthException('Registrierung fehlgeschlagen.');
      }
    }

    // ✅ Nur bei Erfolg weiterleiten
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  } on AuthException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ein unbekannter Fehler ist aufgetreten.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    final buttonText = isLogin ? 'Einloggen' : 'Registrieren';

    return Scaffold(
      appBar: AppBar(title: const Text('FocusPilot Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : handleAuth,
              child: Text(isLogin ? 'Einloggen' : 'Registrieren'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? 'Noch keinen Account? Jetzt registrieren.'
                  : 'Bereits registriert? Jetzt einloggen.'),
            ),

            
          ],
        ),
      ),
    );
  }
}
