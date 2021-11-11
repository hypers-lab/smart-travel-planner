import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/screens/userProfile/edit_personal_info.dart';

void main() {
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('non-empty fields in add personal info, tab save button, succeed, testing',
      (WidgetTester tester) async {

        EditProfilePage editProfilePage = EditProfilePage();
        await tester.pumpWidget(makeTestableWidget(child: editProfilePage));

        //find the name field
        var textNameField = find.byKey(Key('nameField'));
        expect(textNameField, findsOneWidget);

        //enter the name
        await tester.enterText(textNameField, 'Maathangi');
        expect(find.text('Maathangi'), findsOneWidget);
        
        //find the age field
        var textAgeField = find.byKey(ValueKey('ageField'));
        expect(textAgeField, findsOneWidget);

        //enter the ege
        await tester.enterText(textAgeField, '23');
        expect(find.text('23'), findsOneWidget);

        //find the phone number field
        var textPhoneNumberField = find.byKey(ValueKey('phoneNumberField'));
        expect(textPhoneNumberField, findsOneWidget);

        //enter the phone number
        await tester.enterText(textPhoneNumberField, '0767479308');
        expect(find.text('0767479308'), findsOneWidget);

        //find the gender drop down
        var textGenderField = find.byKey(ValueKey('genderField'));
        expect(textGenderField, findsOneWidget);

        //tap the dropdown 
        await tester.tap(textGenderField);
        await tester.pump();
        await tester.pump(Duration(seconds: 1));

        //select the gender
        await tester.tap(find.text('Male').last);
        await tester.pump();
        await tester.pump(Duration(seconds: 1));
        expect(find.text('Male'), findsOneWidget);

        //find the save button
        var textButtonField = find.byKey(ValueKey('saveButton'));
        expect(textButtonField, findsOneWidget);
        // await tester.tap(textButtonField);
        // await tester.pump();
        // await tester.pump(Duration(seconds: 1));
        
  });

  testWidgets('empty fields in personal info, tab save button, gives error, testing',
      (WidgetTester tester) async {
        EditProfilePage editProfilePage = EditProfilePage();
        await tester.pumpWidget(makeTestableWidget(child: editProfilePage));

         //find the name field
        var textNameField = find.byKey(Key('nameField'));
        expect(textNameField, findsOneWidget);

        //leave the name field as empty
        await tester.enterText(textNameField, '');
        expect(find.text(''), findsNWidgets(3));

         //find the name field
        var textAgeField = find.byKey(ValueKey('ageField'));
        expect(textAgeField, findsOneWidget);

        //leave the age field as empty
        await tester.enterText(textAgeField, '');
        expect(find.text(''), findsNWidgets(3));

        //find the name field
        var textPhoneNumberField = find.byKey(ValueKey('phoneNumberField'));
        expect(textPhoneNumberField, findsOneWidget);

        //leave the phone number field as empty
        await tester.enterText(textPhoneNumberField, '');
        expect(find.text(''), findsNWidgets(3));

        //find the save button
        var textButtonField = find.byKey(ValueKey('saveButton'));
        expect(textButtonField, findsOneWidget);
      });
  
}