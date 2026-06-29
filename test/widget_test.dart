import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:romaquest/screens/welcomePage.dart';

void main() {
  testWidgets('welcome screen shows the primary call to action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WelcomePage(),
      ),
    );

    expect(find.text('WELCOME TO ROME...'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
