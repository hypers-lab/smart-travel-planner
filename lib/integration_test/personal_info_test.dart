import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_travel_planner/screens/userProfile/edit_personal_info.dart';
import 'package:smart_travel_planner/screens/userProfile/personal_info.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Personal information test',
    (WidgetTester tester) async {
      //app.main();
      await tester.pumpAndSettle();

      //Arrange
      final userName = find.byKey(ValueKey('nameField'));
      final userAge = find.byKey(ValueKey('ageField'));
      final userPhoneNumber = find.byKey(ValueKey('phoneNumberField'));
      final userGender = find.byKey(ValueKey('genderField'));
      final savebtn = find.byKey(ValueKey('saveButton'));

      // Act
      await tester.enterText(userName, 'Maathangi');
      //await tester.pumpAndSettle();

      await tester.enterText(userAge, '23');
      //await tester.pumpAndSettle();

      await tester.enterText(userPhoneNumber, '0767479307');
      //await tester.pumpAndSettle();

      await tester.enterText(userGender, 'Female');
      //await tester.pumpAndSettle();

      await tester.tap(savebtn, warnIfMissed: true);
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfilePage), findsNothing);
      expect(find.byType(PersonalInfoScreen), findsOneWidget);
      expect(find.text('Maathangi'), findsOneWidget);
      expect(find.text('23'), findsOneWidget);
      expect(find.text('0767479307'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byType(PersonalInfoScreen), findsNothing);
    },
  );
}
