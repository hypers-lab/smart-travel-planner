import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/main.dart';
import 'package:smart_travel_planner/screens/places/details.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Details Screen integration test', () {

    group('DetailsSearchScreen preview testing', () {

      TravelDestination travelDestination = TravelDestination(
          businessStatus: "OPERATIONAL",
          placeId: "ChIJUbf3iDiuEmsROJxXbhYO7cM",
          placeName: "Electricity Board Maligawatta Office",
          photoReference:
          "Aap_uEDLaDIBdiNZHKrSNge3HUDInZaOXr2y7afYAO7RirikSaNhwLtueLTzfx92xLzSRzpeLZ9Vy58SxENPTgngZ1S9RrO3USMYRxs2oXF33c4eTMrARdsJlmlQ5y0ZGDFnFFQU2WMgOOs930V-FdmoPbduvD74Io5e8RQnQAVUyQPDRzCm",
          rating: "4.1",
          userRatingsTotal: "15",
          latitude: 6.9321595,
          longitude: 79.86821929999999,
          description: "H. R. Jothipala Mw., Colombo",
          openStatus: "false",
          address: "WVJ9+V7 Colombo, Sri Lanka");

      List<int> list = 'SampleImage'.codeUnits;
      Uint8List image = Uint8List.fromList(list);

      PlaceInformation placeInformation =
      PlaceInformation(travelDestination, image);


      testWidgets('Details screen view rendering testing', (WidgetTester tester) async {
        await Firebase.initializeApp();
        await tester.pumpWidget(MyApp());
        await tester.pump(Duration(seconds: 5));
        await tester.enterText(
            find.byKey(Key('EmailTextFormField')), 'dulajkavinda.1998@gmail.com');
        await tester.enterText(find.byKey(Key('PasswordTextFormField')), 'abcd1234');
        await tester.press(find.byKey(Key('LoginButton')),warnIfMissed: false);
        await tester.pump(Duration(seconds: 40));
        await tester.pumpAndSettle();
        await tester.pumpWidget(Details(place: placeInformation));
        await tester.pump(Duration(seconds: 20));
        await tester.pumpAndSettle();
        

        expect(find.byKey(Key('details-screen-scrollview')), findsOneWidget);
      });

    });
  });
}

//flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/detailsscreen_test.dart --no-sound-null-safety