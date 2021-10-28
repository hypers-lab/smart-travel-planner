import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';

class TravelDestination {
  TravelDestination({
    required this.businessStatus,
    required this.placeId,
    required this.placeName,
    required this.photoReference,
    required this.rating,
    required this.userRatingsTotal,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.openStatus,
    required this.address,
  });

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
  void markPlaceAsVisited(PlaceInformation place) {
    final String uid = getCurrentUserId();

    FirebaseFirestore.instance.collection("visitedPlaces").add({
      "address": place.travelDestination.address,
      "businessStatus": place.travelDestination.businessStatus,
      "comment": "",
      "description": place.travelDestination.description,
      "latitude": place.travelDestination.latitude,
      "longitude": place.travelDestination.longitude,
      "openStatus": place.travelDestination.openStatus,
      "photoReference": place.travelDestination.photoReference,
      "placeId": place.travelDestination.placeId,
      "placeName": place.travelDestination.placeName,
      "rating": place.travelDestination.rating,
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
