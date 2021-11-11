import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:smart_travel_planner/appBrain/Preferences.dart';
import 'package:test/test.dart';

void main() {
  group('UserPreferences:', () {
    test('UserPreferences object should be created.', () {
      UserPreferences userPreferences = UserPreferences(
          areas: ['Kandy','Jaffna'], types: ['Lodging'],
      );
      expect(userPreferences.types, ['Lodging']);
      expect(userPreferences.areas, ['Kandy','Jaffna']);
    });

    test('User Preferences should be recorded.', () async {
      final instance = MockFirestoreInstance();
      await instance
      .collection("userPreferences")
      .doc('xjtZPHcYBVWbKGcTkpALlfGkWoM2')
      .update({
        'preferredTypes': ['Lodging'],
        'preferredAreas': ['Kandy','Jaffna'],
      });

      final snapshot = await instance
      .collection('userPreferences')
      .get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['preferredAreas'],
          ['Kandy','Jaffna']);

      instance.dump();
    });
  });
}