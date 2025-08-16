import 'package:supabase_flutter/supabase_flutter.dart';

class GPTService {
  static Future<String> sendPrompt(String prompt) async {
    final response = await Supabase.instance.client.functions.invoke(
      'gpt',
      body: {'prompt': prompt},
    );

    if (response.status == 200) {
      final json = Map<String, dynamic>.from(response.data);
      return json['reply'] ?? 'Keine Antwort erhalten.';
    } else if (response.status == 403) {
      throw Exception('Du hast dein kostenloses GPT-Limit erreicht.');
    } else if (response.status == 401) {
      throw Exception('Nicht eingeloggt.');
    } else {
      throw Exception('Unbekannter Fehler: ${response.data}');
    }
  }
}
