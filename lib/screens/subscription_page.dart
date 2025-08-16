import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = 'ideenschmiede'; // free
  String selectedStorage = 'none';

  Future<void> startCheckout() async {
    final url = Uri.parse(
        'https://nmjnjoivqlvqnmkslhmj.functions.supabase.co/create_checkout');

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'plan': selectedPlan,
        'storage': selectedStorage,
      }),
    );

    if (res.statusCode == 200) {
      final sessionUrl = jsonDecode(res.body)['url'];
      if (sessionUrl is String) {
        await launchUrl(Uri.parse(sessionUrl),
            mode: LaunchMode.externalApplication);
      } else {
        _toast('Unerwartete Antwort.');
      }
    } else {
      _toast('Fehler beim Erstellen der Checkout-Session.');
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isFreePlan = selectedPlan == 'ideenschmiede';
    final isCheckoutEnabled = !isFreePlan; // Free-Plan: Button deaktiviert

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.eco, color: Colors.green),
                SizedBox(width: 8),
                Text('FocusPilot',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
            const SizedBox(height: 24),

            // --- PLANS ---
            _planCard(
              icon: Icons.lightbulb_outline,
              value: 'ideenschmiede',
              title: 'Ideenschmiede',
              price: '0€',
              features: const [
                'Begrenzte Funktionen',
                'Ideal zum Testen',
              ],
            ),
            _planCard(
              icon: Icons.bolt,
              value: 'ideenprofi',
              title: 'Ideenprofi',
              price: '5€/Monat',
              features: const [
                '100 GPT-Nachrichten/Monat',
                'Grundfunktionen',
              ],
            ),
            _planCard(
              icon: Icons.track_changes,
              value: 'werkstatt',
              title: 'Werkstatt',
              price: '9€/Monat',
              features: const [
                '250 GPT-Nachrichten/Monat',
                'Erweiterte Funktionen',
              ],
            ),
            _planCard(
              icon: Icons.build,
              value: 'manufaktur',
              title: 'Manufaktur',
              price: '20€/Monat',
              features: const [
                '2000 GPT-Nachrichten/Monat',
                'Aufgaben & Projekte',
                'Strukturierter Coach',
              ],
            ),
            _planCard(
              icon: Icons.science,
              value: 'all_in',
              title: 'Forschungslabor',
              price: '35€/Monat',
              features: const [
                'Unbegrenzte GPT-Nutzung (Fair Use)',
                'Alle Funktionen freigeschaltet',
                'Priorisierter Support',
              ],
            ),

            const SizedBox(height: 24),
            const Text('Speicher (optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),

            // --- STORAGE (disabled im Free-Plan) ---
            Wrap(
              spacing: 8,
              children: [
                _storageChip('none', 'Kein Speicher', enabled: !isFreePlan),
                _storageChip('1gb', '1 GB (+1€)', enabled: !isFreePlan),
                _storageChip('10gb', '10 GB (+5€)', enabled: !isFreePlan),
              ],
            ),
            if (isFreePlan)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Speicher ist im Free-Plan nicht buchbar.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),

            const SizedBox(height: 24),
            // --- BUTTON (disabled im Free-Plan) ---
            ElevatedButton(
              onPressed: isCheckoutEnabled ? startCheckout : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.green.shade200,
              ),
              child: const Text(
                'Jetzt buchen mit Stripe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard({
    required IconData icon,
    required String value,
    required String title,
    required String price,
    required List<String> features,
  }) {
    final isSelected = selectedPlan == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = value;
          if (selectedPlan == 'ideenschmiede') {
            selectedStorage = 'none'; // Free-Plan: Speicher immer none
          }
        });
      },
      child: Card(
        color: isSelected ? Colors.green.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Text(price,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
              ...features.map((f) => Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(f)),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storageChip(String value, String label, {required bool enabled}) {
    final isSelected = selectedStorage == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: enabled
          ? (_) => setState(() => selectedStorage = value)
          : null,
      selectedColor: Colors.green.shade100,
      disabledColor: Colors.grey.shade200,
    );
  }
}
