import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/screens/userProfile/history.dart';

void main() {
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('history screen, succeed testing',
      (WidgetTester tester) async {
        
        await Firebase.initializeApp();
        
        History history = History();
        await tester.pumpWidget(makeTestableWidget(child: history));

      });
}