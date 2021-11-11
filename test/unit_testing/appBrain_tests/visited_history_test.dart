
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
  });
}