import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/main.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CategorySearch Screen integration test', () {

    group('CategorySearchScreen initial preview testing', () {
      testWidgets('CategorySearch scroll view testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')));
        await tester.pump(Duration(seconds: 40));
        await tester.pumpAndSettle();
        await tester.press(find.byKey(Key('category-button')));
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('CategorySearch dropdown rendering testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 40));
        await tester.pumpAndSettle();
        await tester.press(find.byKey(Key('category-button')));
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('category-select-dropdown')), findsOneWidget);
      });

      });
    });
}

//flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/categoryscreen_test.dart --no-sound-null-safety