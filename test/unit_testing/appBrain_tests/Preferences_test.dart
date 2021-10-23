import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:smart_travel_planner/appBrain/Preferences.dart';
import 'package:test/test.dart';

void main() {
  group('UserPreferences:', () {
    test('UserPreferences object should be created.', () {
      UserPreferences userPreferences = UserPreferences(
          places: ['Jaffna','Kandy'],
          times: ['morning','evening'],
          areas: ['Mountains','Beach'],
          days: ['Saturday','Tuesday']
      );

      expect(userPreferences.places, ['Jaffna','Kandy']);
      expect(userPreferences.times, ['morning','evening']);
      expect(userPreferences.areas, ['Mountains','Beach']);
      expect(userPreferences.days, ['Saturday','Tuesday']);
      
    });

    test('User Preferences should be recorded.', () async {
      final instance = MockFirestoreInstance();
      await instance
      .collection("user_preferences")
      .doc('xjtZPHcYBVWbKGcTkpALlfGkWoM2')
      .update({
        'places': ['Jaffna','Kandy'],
        'prefered_times': ['morning','evening'],
        'prefered_areas': ['Mountains','Beach'],
        'prefered_days': ['Saturday','Tuesday']
      });

      final snapshot = await instance
      .collection('user_preferences')
      .get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['places'],
          ['Jaffna','Kandy']);

      instance.dump();
    });
  });
}