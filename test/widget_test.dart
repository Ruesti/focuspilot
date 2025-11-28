// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:focuspilot/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Wir pumpen einfach deine Haupt-App und schauen, ob es ohne Fehler rendert.
    await tester.pumpWidget(const FocusPilotApp());
  });
}
