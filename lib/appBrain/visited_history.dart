import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VisitedHistory {
  VisitedHistory( 
      {required this.placeName,
      required this.reviewScore,
      required this.city,
      required this.address,
      });

  String placeName;
  String reviewScore;
  String city;
  String address;


  //get Current user's id
  static String getCurrentUserId() {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user!.uid;
      return uid;
    } catch (e) {
      print('Firebase Authorization failed!');
    }
    return "";
  }

  //get all the place details of current user visited
  getVisitedPlaces() {
    final String uid = getCurrentUserId();
    FirebaseFirestore.instance
        .collection("visitedPlaces")
        .where('userId', isEqualTo: uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        VisitedHistory history = VisitedHistory(
          placeName: result['placeName'],
          reviewScore: result['reviewScore'].toString(),
          city: result['address'],
          address: result['description'],
        );
      });
     
    });
  }
  
}