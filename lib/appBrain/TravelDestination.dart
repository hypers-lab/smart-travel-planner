import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_travel_planner/appBrain/UserReview.dart';
import 'package:smart_travel_planner/util/hoteldata.dart';

class TravelDestination {
  TravelDestination(
      {required this.city,
      required this.placeId,
      required this.placeName,
      required this.mainPhotoUrl,
      required this.reviewScore,
      required this.reviewScoreWord,
      required this.reviewText,
      required this.description,
      required this.coordinates,
      required this.checkout,
      required this.checkin,
      required this.address,
      required this.url,
      required this.introduction});

  String city;
  int placeId;
  String placeName;
  String mainPhotoUrl;
  String reviewScore;
  String reviewScoreWord;
  String reviewText;
  String description;
  String coordinates;
  String checkout;
  String checkin;
  String address;
  String url;
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

  //store places visited information
  void markPlaceAsVisited() {
    final String uid = getCurrentUserId();

    //create a unique document ID
    final String docID = uid + this.placeId.toString();

    final userReview = UserReview(
        placeId: this.placeId, userId: uid, reviewScore: '0.0', comment: "");

    FirebaseFirestore.instance
        .collection("visitedInformation")
        .doc(docID)
        .set({"placeId": userReview.placeId, "userId": userReview.userId});
  }

  //store user reviews and comments
  void addReviewComments(double reviewScore, String comment) {
    final String uid = getCurrentUserId();

    final String docID = uid + this.placeId.toString();

    final userReview = UserReview(
        placeId: this.placeId,
        userId: uid,
        reviewScore: reviewScore.toString(),
        comment: comment);

    FirebaseFirestore.instance.collection("visitedInformation").doc(docID).set({
      "reviewScore": double.parse(userReview.reviewScore),
      "placeId": userReview.placeId,
      "comment": userReview.comment,
      "userId": userReview.userId
    });
  }
}
