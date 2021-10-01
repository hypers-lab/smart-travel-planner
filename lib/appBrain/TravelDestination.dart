import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_travel_planner/appBrain/PlaceReview.dart';
import 'package:smart_travel_planner/appBrain/UserReview.dart';
import 'package:smart_travel_planner/util/hoteldata.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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

  //retrive review data for the current user
  static List<PlaceReview> getReviewHsitoryofUser() {
    List<PlaceReview> reviewData = [];

    final String uid = getCurrentUserId();

    print("UserID: $uid");

    FirebaseFirestore.instance
        .collection("visitedInformation")
        .where("userId", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        UserReview userReview = UserReview(
            placeId: doc["placeId"],
            userId: uid,
            reviewScore: doc["reviewScore"],
            comment: doc["comment"]);

        print(
            "userID: ${userReview.userId}, placeID: ${userReview.placeId.toString()}");

        TravelDestination travelDestination =
            // ignore: await_only_futures
            await getPlaceById(userReview.placeId);

        PlaceReview reviewNplace =
            new PlaceReview(travelDestination, userReview);
        reviewData.add(reviewNplace);
      });
    });

    print("Length : ${reviewData.length}");

    return reviewData;
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

  //get suggestions for a selected place
  static Future<List<TravelDestination>> getSuggestedPlacesFromModel(
      int hotelId) async {
    List<TravelDestination> suggestPlaces = [];
    try {
      String urlName =
          'https://sep-recommender.herokuapp.com/recommend?hotel_id=' +
              hotelId.toString();
      var url = Uri.parse(urlName);
      var response = await http.get(url);
      //print(response);

      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var suggestPlacesIds = jsonResponse['recommended_hotels'];

        for (var i = 0; i < 10; i++) {
          FirebaseFirestore.instance
              .collection("hotels")
              .where("hotelId", isEqualTo: suggestPlacesIds[i])
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              TravelDestination travelDestination = TravelDestination(
                  city: result.data()["city"],
                  placeId: result.data()["hotelId"],
                  placeName: result.data()["hotelName"],
                  mainPhotoUrl: result.data()["mainPhotoUrl"],
                  reviewScore: result.data()["reviewScore"].toString(),
                  reviewScoreWord: result.data()["reviewScoreWord"],
                  reviewText: result.data()["reviewText"],
                  description: result.data()["description"],
                  coordinates: result.data()["coordinates"],
                  checkin: result.data()["checkin"],
                  checkout: result.data()["checkout"],
                  address: result.data()["address"],
                  url: result.data()["url"],
                  introduction: result.data()["introduction"]);
              suggestPlaces.add(travelDestination);
            });
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error: $e");
    }
    return suggestPlaces;
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
