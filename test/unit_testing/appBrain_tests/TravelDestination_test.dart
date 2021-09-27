import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

void main() {
  MockFirestore instance;
  MockQuerySnapshot mockQuerySnapshot;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;

  setUp(() {
    instance = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
  });

  group('TravelDestination', () {
    test('List of TravelDestination objects should be returned', () {
      var placesTestList = TravelDestination.getPlacesDetails();

      expect(placesTestList is List<TravelDestination>, true);
    });
  });
}
