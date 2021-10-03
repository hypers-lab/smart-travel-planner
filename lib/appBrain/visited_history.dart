import 'package:firebase_auth/firebase_auth.dart';

class VisitedHistory {
  VisitedHistory(
      {required this.hotelName,
      required this.reviewScore,
      required this.city,
      required this.address,
      required this.introduction,
      });

  String hotelName;
  String reviewScore;
  String city;
  String address;
  String introduction;


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

  //get all places name
  
}