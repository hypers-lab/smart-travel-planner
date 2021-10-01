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
        placeId: this.placeId, userId: uid, reviewScore: 0.0, comment: "");

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
        reviewScore: reviewScore,
        comment: comment);

    FirebaseFirestore.instance.collection("visitedInformation").doc(docID).set({
      "reviewScore": userReview.reviewScore,
      "placeId": userReview.placeId,
      "comment": userReview.comment,
      "userId": userReview.userId
    });
  }

  //search a place using its id
  static TravelDestination getPlaceById(int placeId) {
    List<TravelDestination> travelDestinations = [];

    FirebaseFirestore.instance
        .collection("hotels")
        .where("hotelId", isEqualTo: placeId)
        .limit(1)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        TravelDestination travelDestination = TravelDestination(
            city: doc.data()["city"],
            placeId: doc.data()["hotelId"],
            placeName: doc.data()["hotelName"],
            mainPhotoUrl: doc.data()["mainPhotoUrl"],
            reviewScore: doc.data()["reviewScore"].toString(),
            reviewScoreWord: doc.data()["reviewScoreWord"],
            reviewText: doc.data()["reviewText"],
            description: doc.data()["description"],
            coordinates: doc.data()["coordinates"],
            checkin: doc.data()["checkin"],
            checkout: doc.data()["checkout"],
            address: doc.data()["address"],
            url: doc.data()["url"],
            introduction: doc.data()["introduction"]);

        print("placeName: ${travelDestination.placeName}");
        travelDestinations.add(travelDestination);
      });
    });
    return travelDestinations[0];
  }

  //data retrieve from firebase
  static List<TravelDestination> getPlacesDetails() {
    List<TravelDestination> places = [];
    try {
      FirebaseFirestore.instance
          .collection("hotels")
          .limit(10)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          TravelDestination travelDestination = TravelDestination(
              city: doc["city"],
              placeId: doc["hotelId"],
              placeName: doc["hotelName"],
              mainPhotoUrl: doc["mainPhotoUrl"],
              reviewScore: doc["reviewScore"].toString(),
              reviewScoreWord: doc["reviewScoreWord"],
              reviewText: doc["reviewText"],
              description: doc["description"],
              coordinates: doc["coordinates"],
              checkin: doc["checkin"],
              checkout: doc["checkout"],
              address: doc["address"],
              url: doc["url"],
              introduction: doc["introduction"]);
          places.add(travelDestination);
        });
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    }
    return places;
  }

  //dummy data taking
  static List<TravelDestination> getPlacesDetailsDummy() {
    List<TravelDestination> places = [];
    try {
      hotelsdata.forEach((doc) {
        TravelDestination travelDestination = TravelDestination(
            city: doc["city"],
            placeId: doc["hotelId"],
            placeName: doc["hotelName"],
            mainPhotoUrl: doc["mainPhotoUrl"],
            reviewScore: doc["reviewScore"].toString(),
            reviewScoreWord: doc["reviewScoreWord"],
            reviewText: doc["reviewText"],
            description: doc["description"],
            coordinates: doc["coordinates"],
            checkin: doc["checkin"],
            checkout: doc["checkout"],
            address: doc["address"],
            url: doc["url"],
            introduction: doc["introduction"]);

        places.add(travelDestination);
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    }
    return places;
  }
}
