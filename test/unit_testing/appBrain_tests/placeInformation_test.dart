import 'dart:typed_data';

import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:test/test.dart';

void main() {
  group('PlaceInformation:', () {
    test('PlaceInformation object should be created.', () async {
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
          address: "WVJ9+V7 Colombo, Sri Lanka",
          weather: null);

      List<int> list = 'SampleImage'.codeUnits;
      Uint8List image = Uint8List.fromList(list);

      PlaceInformation placeInformation =
          PlaceInformation(travelDestination, image);

      expect(placeInformation.travelDestination.placeName,
          "Electricity Board Maligawatta Office");
    });
  });
}
