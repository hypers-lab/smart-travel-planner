
//import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:smart_travel_planner/appBrain/visited_history.dart';
import 'package:test/test.dart';

void main() {
  group('VisitedHistory:', () {
    test('VisitedHistory object should be created.', () {
      VisitedHistory visitedHistory = VisitedHistory(
        placeName: 'H.Brothers', 
        reviewScore: '0.0', 
        city: 'Colombo', 
        address: '163Ven Baddegama Wimalawansa Mawatha, Colombo', 
      );

      expect(visitedHistory.placeName,'H.Brothers' );
      expect(visitedHistory.reviewScore, '0.0');
      expect(visitedHistory.city, 'Colombo');
      expect(visitedHistory.address, '163Ven Baddegama Wimalawansa Mawatha, Colombo');
      
    });

  //   test('Visited places details should be recorded.', () async {
  //     final instance = MockFirestoreInstance();
  //     final snaapshot=await instance
  //     .collection("visitedPlaces")
  //     .where('userId', isEqualTo: 'xjtZPHcYBVWbKGcTkpALlfGkWoM2')
  //       .get()
  //       .then((querySnapshot) async {
  //     querySnapshot.docs.forEach((result) {
  //       VisitedHistory history = VisitedHistory(
  //         placeName: result['placeName'],
  //         reviewScore: result['reviewScore'].toString(),
  //         city: result['address'],
  //         address: result['description'],
  //       );
  //     });

  //     final snapshot = await instance
  //     .collection('visitedPlaces')
  //     .get();

  //     expect(snapshot.docs.length, 1);
  //     expect(snapshot.docs.first['placeName'],
  //         "");

  //     instance.dump();
  //   });
  // });
  });
}