import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:test/test.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

void main() {
  group('TravelDestination:', () {
    test('TravelDestination object should be created.', () {
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

      expect(travelDestination.businessStatus, "OPERATIONAL");
      expect(travelDestination.placeId, "ChIJUbf3iDiuEmsROJxXbhYO7cM");
      expect(
          travelDestination.placeName, "Electricity Board Maligawatta Office");
      expect(travelDestination.photoReference,
          "Aap_uEDLaDIBdiNZHKrSNge3HUDInZaOXr2y7afYAO7RirikSaNhwLtueLTzfx92xLzSRzpeLZ9Vy58SxENPTgngZ1S9RrO3USMYRxs2oXF33c4eTMrARdsJlmlQ5y0ZGDFnFFQU2WMgOOs930V-FdmoPbduvD74Io5e8RQnQAVUyQPDRzCm");
      expect(travelDestination.rating, "4.1");
      expect(travelDestination.userRatingsTotal, "15");
      expect(travelDestination.latitude, 6.9321595);
      expect(travelDestination.longitude, 79.86821929999999);
      expect(travelDestination.description, "H. R. Jothipala Mw., Colombo");
      expect(travelDestination.openStatus, "false");
      expect(travelDestination.address, "WVJ9+V7 Colombo, Sri Lanka");
    });

    test('Visited place information should be recorded.', () async {
      final instance = MockFirestoreInstance();

      await instance.collection("visitedPlaces").add({
        "address": "WVJ9+V7 Colombo, Sri Lanka",
        "businessStatus": "OPERATIONAL",
        "comment": "",
        "description": "H. R. Jothipala Mw., Colombo",
        "latitude": 6.9321595,
        "longitude": 79.86821929999999,
        "openStatus": "false",
        "photoReference":
            "Aap_uEDLaDIBdiNZHKrSNge3HUDInZaOXr2y7afYAO7RirikSaNhwLtueLTzfx92xLzSRzpeLZ9Vy58SxENPTgngZ1S9RrO3USMYRxs2oXF33c4eTMrARdsJlmlQ5y0ZGDFnFFQU2WMgOOs930V-FdmoPbduvD74Io5e8RQnQAVUyQPDRzCm",
        "placeId": "ChIJUbf3iDiuEmsROJxXbhYO7cM",
        "placeName": "Electricity Board Maligawatta Office",
        "rating": "4.1",
        "reviewScore": 0.0,
        "userId": "rDmvYdBXHWfcQmSViTSJKADycpf2",
        "userRatingsTotal": "41"
      });

      final snapshot = await instance.collection('visitedPlaces').get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['placeName'],
          "Electricity Board Maligawatta Office");

      instance.dump();
    });

    test('Review and Rating for a place should be recorded.', () async {
      final instance = MockFirestoreInstance();

      await instance.collection("visitedPlaces").add({
        "address": "WVJ9+V7 Colombo, Sri Lanka",
        "businessStatus": "OPERATIONAL",
        "comment": "Nice Place! Enjoyed",
        "description": "H. R. Jothipala Mw., Colombo",
        "latitude": 6.9321595,
        "longitude": 79.86821929999999,
        "openStatus": "false",
        "photoReference":
            "Aap_uEDLaDIBdiNZHKrSNge3HUDInZaOXr2y7afYAO7RirikSaNhwLtueLTzfx92xLzSRzpeLZ9Vy58SxENPTgngZ1S9RrO3USMYRxs2oXF33c4eTMrARdsJlmlQ5y0ZGDFnFFQU2WMgOOs930V-FdmoPbduvD74Io5e8RQnQAVUyQPDRzCm",
        "placeId": "ChIJUbf3iDiuEmsROJxXbhYO7cM",
        "placeName": "Electricity Board Maligawatta Office",
        "rating": "4.1",
        "reviewScore": 4.0,
        "userId": "rDmvYdBXHWfcQmSViTSJKADycpf2",
        "userRatingsTotal": "41"
      });

      final snapshot = await instance.collection('visitedPlaces').get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['reviewScore'], 4.0);
      expect(snapshot.docs.first['comment'], "Nice Place! Enjoyed");

      instance.dump();
    });
  });
}
