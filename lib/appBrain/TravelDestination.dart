import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_travel_planner/appBrain/UserReview.dart';

class TravelDestination {
  TravelDestination(
      {required this.businessStatus,
      required this.placeId,
      required this.placeName,
      required this.photoReference,
      required this.rating,
      required this.userRatingsTotal,
      required this.latitude,
      required this.longitude,
      required this.description,
      required this.openStatus,
      required this.address});

  String businessStatus;
  double latitude;
  double longitude;
  String placeName;
  String openStatus;
  String placeId;
  String address;
  String rating;
  String userRatingsTotal;
  String photoReference;
  String description;

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

  //store visited place information
  void markPlaceAsVisited() {
    final String uid = getCurrentUserId();

    FirebaseFirestore.instance.collection("visitedPlaces").add({
      "address": address,
      "businessStatus": businessStatus,
      "comment": "",
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "openStatus": openStatus,
      "photoReference": photoReference,
      "placeId": placeId,
      "placeName": placeName,
      "rating": rating,
      "reviewScore": 0.0,
      "userId": uid,
      "userRatingsTotal": userRatingsTotal
    });
  }

  //store user reviews and comments
  void addReviewComments(double reviewScore, String comment) {
    final String uid = getCurrentUserId();

    FirebaseFirestore.instance.collection("visitedPlaces").add({
      "address": address,
      "businessStatus": businessStatus,
      "comment": comment,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "openStatus": openStatus,
      "photoReference": photoReference,
      "placeId": placeId,
      "placeName": placeName,
      "rating": rating,
      "reviewScore": reviewScore,
      "userId": uid,
      "userRatingsTotal": userRatingsTotal
    });
  }
}
