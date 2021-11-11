import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/screens/userProfile/change_password.dart';

void main() {
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Non empty field, Change password, succeed testing',
      (WidgetTester tester) async {

        ChangePassword changePassword = ChangePassword();
        await tester.pumpWidget(makeTestableWidget(child: changePassword));

        //find old password field
        var textOldPasswordField = find.byKey(Key('oldPassword'));
        expect(textOldPasswordField, findsOneWidget);

        //enter the old password
        await tester.enterText(textOldPasswordField, 'abcdef56');
        expect(find.text('abcdef56'), findsOneWidget);
        
        //find new password field
        var textNewPasswordField = find.byKey(Key('newPassword'));
        expect(textNewPasswordField, findsWidgets);

        //enter a new password
        await tester.enterText(textNewPasswordField, 'abcdef57');
        expect(find.text('abcdef57'), findsOneWidget);

        //find the confirm password field
        var textConfirmPasswordField = find.byKey(Key('confirmPassword'));
        expect(textConfirmPasswordField, findsOneWidget);

        //enter the new password again
        await tester.enterText(textConfirmPasswordField, 'abcdef57');
        expect(find.text('abcdef57'), findsNWidgets(2));

        //find the save button
        var textButtonField = find.byKey(ValueKey('saveButtonPassword'));
        expect(textButtonField, findsOneWidget);

      });
  
  testWidgets('empty field, Change password, succeed testing',
      (WidgetTester tester) async {

        ChangePassword changePassword = ChangePassword();
        await tester.pumpWidget(makeTestableWidget(child: changePassword));
        
        //find the old password field
        var textOldPasswordField = find.byKey(Key('oldPassword'));
        expect(textOldPasswordField, findsOneWidget);

        //leave the old password field as empty
        await tester.enterText(textOldPasswordField, '');
        expect(find.text(''), findsNWidgets(3));

        //find the new password field
        var textNewPasswordField = find.byKey(Key('newPassword'));
        expect(textNewPasswordField, findsWidgets);

        //leave new password field as empty
        await tester.enterText(textNewPasswordField, '');
        expect(find.text(''), findsNWidgets(3));

        //find the cofirm password field
        var textConfirmPasswordField = find.byKey(Key('confirmPassword'));
        expect(textConfirmPasswordField, findsOneWidget);

        //leave the repeat password field as empty
        await tester.enterText(textConfirmPasswordField, '');
        expect(find.text(''), findsNWidgets(3));

        //find the save button
        var textButtonField = find.byKey(ValueKey('saveButtonPassword'));
        expect(textButtonField, findsOneWidget);

      });
}