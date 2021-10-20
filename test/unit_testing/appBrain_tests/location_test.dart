import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:test/test.dart';

void main() {
  group('Location:', () {
    test('Location object should be created.', () {
      PlaceLocation placeLocation = PlaceLocation(
          latitude: 6.9321595,
          longitude: 79.86821929999999,
          placeName: "Electricity Board Maligawatta Office");

      expect(placeLocation.latitude, 6.9321595);
      expect(placeLocation.longitude, 79.86821929999999);
      expect(placeLocation.placeName, "Electricity Board Maligawatta Office");
    });
  });
}
