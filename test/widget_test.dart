import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:romaquest/screens/favoritesPage.dart';
import 'package:romaquest/screens/placedetailsPage.dart';
import 'package:romaquest/screens/visited.dart';
import 'package:romaquest/screens/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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

  testWidgets('favorites screen shows empty state when nothing is saved', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavouritesPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No favourite places yet. Tap the heart on a place to save it here.'),
      findsOneWidget,
    );
  });

  testWidgets('visited screen shows empty state when nothing is saved', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Visited(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No visited places yet. Add one from a place details screen.'),
      findsOneWidget,
    );
  });

  testWidgets('add to visited stores the selected place', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlaceDetailsScreen(
          name: 'Colosseum',
          image: 'assets/images/Colosseum.jpg',
          description: 'Historic amphitheatre in Rome.',
          rating: 5,
          hours: '9:00 AM - 6:00 PM',
          days: 'Monday - Sunday',
          category: 'Attractions',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Visited'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final visitedString = prefs.getString('visitedPlaces');
    final visitedList = json.decode(visitedString!) as List<dynamic>;

    expect(
      visitedList.any((place) => place['name'] == 'Colosseum'),
      isTrue,
    );
    expect(find.text('Visited'), findsOneWidget);
  });
}
