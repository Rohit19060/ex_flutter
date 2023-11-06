import 'package:flutter/material.dart';
import 'package:flutter_experiments/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End to End Test', () {
    testWidgets('App Test', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Hello');
      await tester.enterText(find.byType(TextField).at(1), 'Hello');
      expect(find.text('Hello'), findsWidgets);
    });
  });
}
