import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByCity(String searchField) {
    return FirebaseFirestore.instance
        .collection('hotels')
        .where('city', isEqualTo: searchField)
        .get();
  }
}
