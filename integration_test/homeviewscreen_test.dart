import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/main.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home View Screen integration test', () {

    group('HomeViewScreen initial preview testing', () {
      testWidgets('Home scroll view testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });


      testWidgets('Recent Visted Places horizontal scroll view testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });


      testWidgets('Preferences horizontal scroll view testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });


      testWidgets('Nearby Places vertical scroll view testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

    });
  });
}

//flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/homeviewscreen_test.dart