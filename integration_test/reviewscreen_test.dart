import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/main.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Review Screen integration test', () {

    group('ReviewScreen initial preview testing', () {
      testWidgets('Review scroll view testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 40));
        await tester.pumpAndSettle();
        await tester.press(find.byKey(Key('review-button')));
        await tester.pump(Duration(seconds: 30));
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
      });


    });
  });
}

//flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/reviewscreen_test.dart --no-sound-null-safety