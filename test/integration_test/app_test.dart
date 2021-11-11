import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_travel_planner/screens/user/LoginScreen.dart';
import 'package:smart_travel_planner/screens/userProfile/change_password.dart';
import 'package:smart_travel_planner/screens/userProfile/edit_personal_info.dart';
import 'package:smart_travel_planner/screens/userProfile/edit_preferences.dart';
import 'package:smart_travel_planner/screens/userProfile/history.dart';
import 'package:smart_travel_planner/screens/userProfile/personal_info.dart';
import 'package:smart_travel_planner/screens/userProfile/preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('personal information test', () {
    testWidgets('add details in "Edit personal info" screen, tap save button,' 
    'navigate to "personal info" screen, with scaffold msg',
        (WidgetTester tester) async {

          await Firebase.initializeApp();
        
          await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

          //type the name in name field
          var textNameField = find.byKey(Key('nameField'));
          expect(textNameField, findsOneWidget);
          await tester.enterText(textNameField, 'Maathangi');
          expect(find.text('Maathangi'), findsOneWidget);

          //type the age in age field
          var textAgeField = find.byKey(ValueKey('ageField'));
          expect(textAgeField, findsOneWidget);
          await tester.enterText(textAgeField, '23');
          expect(find.text('23'), findsOneWidget);

          //type the phone number in phone number field
          var textPhoneNumberField = find.byKey(ValueKey('phoneNumberField'));
          expect(textPhoneNumberField, findsOneWidget);
          await tester.enterText(textPhoneNumberField, '0767463625');
          expect(find.text('0767463625'), findsOneWidget);

          //find the drop down menu for gender
          var textGenderField = find.byKey(ValueKey('genderField'));
          expect(textGenderField, findsOneWidget);
          await tester.tap(textGenderField);
          await tester.pump();
          await tester.pump(Duration(seconds: 1));

          //select the gender from drop down
          await tester.tap(find.text('Male').last);
          await tester.pump();
          await tester.pump(Duration(seconds: 1));
          expect(find.text('Male'), findsOneWidget);

          //find the save button
          var textButtonField = find.byKey(ValueKey('saveButton'));
          expect(textButtonField, findsOneWidget);

          //press the save button---
          await tester.tap(textButtonField);
          await tester.pumpAndSettle();  
          await tester.pump(Duration(seconds: 20));

          //show the snack bar---
          var snackbar = find.byKey(ValueKey("snackbarEditPersonalInfo")) ;
          expect(snackbar, findsOneWidget);  
          await tester.pumpAndSettle();

          //show the details in Your personal info screen---
          expect(find.byWidget(EditProfilePage()), findsNothing);
          expect(find.byWidget(PersonalInfoScreen()), findsOneWidget); 

      
    });

    testWidgets('empty fields in "Edit personal info screen", tap save button,' 
    'gives error msg, does not navigate to "personal info" screen, remains in "Edit personal info" screen',
        (WidgetTester tester) async {
          
          await tester.pumpWidget(MaterialApp(home: EditProfilePage()));

          //tab save button without fill the fields
          var textButtonField = find.byKey(ValueKey('saveButton'));
          expect(textButtonField, findsOneWidget);
          await tester.tap(textButtonField);
          await tester.pumpAndSettle();

          //does not go to Personal info screen
          expect(find.byWidget(EditProfilePage()), findsNothing);
          expect(find.byWidget(PersonalInfoScreen()), findsNothing); 

          //show errors as the fields are empty
          var textEmptyNameErrorField = find.byKey(ValueKey('error-empty-name-field'));
          await tester.pumpAndSettle();
          expect(textEmptyNameErrorField, findsOneWidget);

          var textEmptyAgeErrorField = find.byKey(ValueKey('error-empty-age-field'));
          await tester.pumpAndSettle();
          expect(textEmptyAgeErrorField, findsOneWidget);
          
          var textEmptyPhoneNumberErrorField = find.byKey(ValueKey('error-empty-phone-number-field'));
          await tester.pumpAndSettle();
          expect(textEmptyPhoneNumberErrorField, findsOneWidget);

    });
  });

  group('User preferences test', () {
    testWidgets('add preferences in "Edit preferences" screen, tap save button,' 
    'navigate to preferences screen, with scaffold msg',
        (WidgetTester tester) async {

          await Firebase.initializeApp();
        
          await tester.pumpWidget(MaterialApp(home: Preference()));

          //find area dropdown
          var textAreaField = find.byKey(ValueKey('area'));
          expect(textAreaField, findsOneWidget);
          await tester.tap(textAreaField);
          await tester.pump();
          await tester.pump(Duration(seconds: 1));

          //selec a preferred place
          await tester.tap(find.text('Ampara').last);
          await tester.pump();
          await tester.pump(Duration(seconds: 1));
          expect(find.text('Ampara'), findsWidgets);

          //find place drop down
          var textPlaceField = find.byKey(ValueKey('place'));
          await tester.ensureVisible(find.byKey(ValueKey('place')));
          await tester.pumpAndSettle();
          expect(textPlaceField, findsOneWidget);
          await tester.tap(textPlaceField);
          await tester.pump();
          await tester.pump(Duration(seconds: 30));

          await tester.ensureVisible(find.text('Lodge').first);
          await tester.pumpAndSettle();

          //select a preferred place type
          await tester.tap(find.text('Lodge').first);
          await tester.pump();
          await tester.pump(Duration(seconds: 30));
          expect(find.text('Lodge'), findsWidgets);

          //find save button
          var textButtonField = find.byKey(ValueKey('saveButtonPreference'));
          expect(textButtonField, findsOneWidget);

          //press save button---
          await tester.tap(textButtonField);
          await tester.pump();  
          await tester.pump(Duration(seconds: 20));

          //snackbar is shown---
          var snackbar = find.byKey(ValueKey("snackbarPreference")) ;
          expect(snackbar, findsOneWidget);  
          await tester.pumpAndSettle();

          //show the user preference in Your preferences screen---
          expect(find.byWidget(Preference()), findsNothing);
          expect(find.byWidget(PreferenceOfUser()), findsOneWidget); 
          
    });
    //pass
    testWidgets('empty fields in "Edit preferences" screen, tap save button,' 
    'gives error msg, does not navigate to " Your preferences" screen,' 
    'remains in "Edit preferences" screen',
        (WidgetTester tester) async {

          await Firebase.initializeApp();

          await tester.pumpWidget(MaterialApp(home: Preference()));

          //find the save button
          var textButtonField = find.byKey(ValueKey('saveButtonPreference'));
          expect(textButtonField, findsOneWidget);

          //press save button with empty fields---
          await tester.tap(textButtonField);
          await tester.pumpAndSettle();

          //navigate to preferences screen where user preferences were erased
          expect(find.byWidget(Preference()), findsOneWidget);
          expect(find.byWidget(PreferenceOfUser()), findsNothing); 

      
    });
  });

  group('Change password test', () {
    testWidgets('non-empty fields in change password screen, press save,' 
    'navigate to login screen, with scaffold msg',
        (WidgetTester tester) async {

          await Firebase.initializeApp();
        
          await tester.pumpWidget(MaterialApp(home: ChangePassword()));

          //type the old password
          var textOldPasswordField = find.byKey(Key('oldPassword'));
          expect(textOldPasswordField, findsOneWidget);
          await tester.enterText(textOldPasswordField, 'abcdef56');
          expect(find.text('abcdef56'), findsOneWidget);

          //type the new password
          var textNewPasswordField = find.byKey(Key('newPassword'));
          expect(textNewPasswordField, findsWidgets);
          await tester.enterText(textNewPasswordField, 'abcdef57');
          expect(find.text('abcdef57'), findsOneWidget);

          //type new password again
          var textConfirmPasswordField = find.byKey(Key('confirmPassword'));
          expect(textConfirmPasswordField, findsOneWidget);
          await tester.enterText(textConfirmPasswordField, 'abcdef57');
          expect(find.text('abcdef57'), findsNWidgets(2));

          //tab save button
          var textButtonPasswordField = find.byKey(ValueKey('saveButtonPassword'));
          expect(textButtonPasswordField, findsOneWidget);
          await tester.tap(textButtonPasswordField);
          await tester.pumpAndSettle();

          //navigate to login screen
          expect(find.byWidget(ChangePassword()), findsNothing);
          expect(find.byWidget(LoginScreen()), findsOneWidget); 
      
    });

    testWidgets('empty fields change password screen, press save,' 
    'gives error msg, does not navigate to login screen',
        (WidgetTester tester) async {
      
          await tester.pumpWidget(MaterialApp(home: ChangePassword()));
          
          //find save button
          var textButtonField = find.byKey(ValueKey('saveButtonPassword'));
          expect(textButtonField, findsOneWidget);

          //tab save button without fill the fields
          await tester.tap(textButtonField);
          await tester.pumpAndSettle();

          //Remains in the change password screen
          expect(find.byWidget(ChangePassword()), findsOneWidget);
          await tester.pumpAndSettle();
          expect(find.byWidget(LoginScreen()), findsNothing); 
          await tester.pumpAndSettle();

          //gives error msg to fill the fields
          var textEmptyOldPasswordField = find.byKey(ValueKey(Key("error-empty-old-password-field"),));
          expect(textEmptyOldPasswordField, findsOneWidget);
          await tester.pumpAndSettle();

          var textEmptyNewPasswordField = find.byKey(ValueKey(Key("error-empty-new-password-field"),));
          expect(textEmptyNewPasswordField, findsOneWidget);
          await tester.pumpAndSettle();

          var textEmptyConfirmPasswordField = find.byKey(ValueKey(Key("error-empty-confirm-password-field"),));
          expect(textEmptyConfirmPasswordField, findsOneWidget);
          
    });
  });

  group('Visited history test', () {
    testWidgets('Search a place in search bar gives that results, succeed test',
        (WidgetTester tester) async {

          await Firebase.initializeApp();
        
          await tester.pumpWidget(MaterialApp(home: History()));

          //find the search bar
          var textSearchbarField = find.byKey(Key('searchbar-history'));
          expect(textSearchbarField, findsOneWidget);

          //search by a place
          await tester.enterText(textSearchbarField, 'H.Brothers');
          //expect(find.text('abcdef56'), findsOneWidget);

          //remains in the history screen
          expect(find.byWidget(History()), findsNothing);
      
    });

  });

} 