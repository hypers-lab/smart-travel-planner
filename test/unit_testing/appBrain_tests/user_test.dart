import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:smart_travel_planner/appBrain/user.dart';
import 'package:test/test.dart';

void main() {
  group('UserDetails:', () {
    test('UserDetails object should be created.', () {
      UserDetails userDetails = UserDetails(
        name: 'maathangi',
        age: '23',
        gender: 'female',
        phonenumber: '0767479308',
      );

      expect(userDetails.name, 'maathangi');
      expect(userDetails.age, '23');
      expect(userDetails.gender, 'female');
      expect(userDetails.phonenumber, '0767479308');
    });

    test('User information should be recorded.', () async {
      final instance = MockFirestoreInstance();
      await instance
          .collection("user_personal_information")
          .doc('xjtZPHcYBVWbKGcTkpALlfGkWoM2')
          .update({
        'name': 'B.Maathangi',
        'age': 28,
        'phone_number': '0777700000',
        'gender': 'female'
      });

      final snapshot =
          await instance.collection('user_personal_information').get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['name'], "B.Maathangi");

      instance.dump();
    });
  });
}
