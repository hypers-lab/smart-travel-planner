import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/screens/userProfile/edit_preferences.dart';

void main() {
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Non empty field, add preferences, succeed testing',
      (WidgetTester tester) async {

        Preference preference = Preference();
        await tester.pumpWidget(makeTestableWidget(child: preference));

        //find area dropdown
        var textAreaField = find.byKey(ValueKey('area'));
        expect(textAreaField, findsOneWidget);

        //tap area drop down 
        await tester.tap(textAreaField);
        await tester.pump();
        await tester.pump(Duration(seconds: 1));

        //tap a prefferred place as Ampara
        await tester.tap(find.text('Ampara').last);
        await tester.pump();
        await tester.pump(Duration(seconds: 1));
        expect(find.text('Ampara'), findsWidgets);

        //find place drop down
        var textPlaceField = find.byKey(ValueKey('place'));
        expect(textPlaceField, findsOneWidget);

        await tester.ensureVisible(textPlaceField);
        await tester.pumpAndSettle();

        //tap place drop down to select a place
        await tester.tap(textPlaceField);
        await tester.pump();
        await tester.pump(Duration(seconds: 30));
        
        //ensure that place is visible
        await tester.ensureVisible(find.text('Lodge').first);
        await tester.pumpAndSettle();

        //select a place as Lodge
        await tester.tap(find.text('Lodge').first);
        await tester.pump();
        await tester.pump(Duration(seconds: 30));
        expect(find.text('Lodge'), findsWidgets);

      });
  
  testWidgets('empty field, add preferences, succeed testing',
      (WidgetTester tester) async {

        Preference preference = Preference();
        await tester.pumpWidget(makeTestableWidget(child: preference));

        //find the area drop down 
        var textAreaField = find.byKey(ValueKey('area'));
        expect(textAreaField, findsOneWidget);

        //tap the area drop down
        await tester.tap(textAreaField);
        await tester.pump();
        await tester.pump(Duration(seconds: 1));

        //tap the cancel button to clear all selection in area dropdown
        await tester.tap(find.byKey(Key("cancelButton1")));
        await tester.pump();
        await tester.pump(Duration(seconds: 1));
        expect(find.text(""), findsNothing);

        //find the place dropdown
        var textPlaceField = find.byKey(ValueKey('place'));
        expect(textPlaceField, findsOneWidget);

        //tap the place drop down
        await tester.tap(textPlaceField);
        await tester.pump();
        await tester.pump(Duration(seconds: 60));

        //ensure that cancel button is visible---
        await tester.ensureVisible(find.byKey(Key("cancelButton2")));
        await tester.pumpAndSettle();

        //tap the cancel button in place drop down to clear the selection---
        await tester.tap(find.byKey(Key("cancelButton2")));
        await tester.pump();
        await tester.pump(Duration(seconds: 30));
        expect(find.text(''), findsNothing);

      });
}