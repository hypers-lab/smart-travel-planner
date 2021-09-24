import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_travel_planner/util/hoteldata.dart';

String collectionName = "hotels";

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

  //data retrive from firebase
  static Future<List<TravelDestination>> getPlacesDetails() async {
    List<TravelDestination> places = [];
    try {
      FirebaseFirestore.instance
          .collection(collectionName)
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

          print(
              "placeName:${travelDestination.placeName}, photo:${travelDestination.mainPhotoUrl} ");

          places.add(travelDestination);
        });
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    } finally {
      return places;
    }
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

        print("placeName:${travelDestination.placeName}, ");

        places.add(travelDestination);
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    } finally {
      return places;
    }
  }
}

//data retrive from firebase
// static List<TravelDestination> getPlacesDetails() {
// List<TravelDestination> places = [];
// try {
// FirebaseFirestore.instance
//     .collection(collectionName)
//     .get()
//     .then((QuerySnapshot querySnapshot) {
// querySnapshot.docs.forEach((doc) {
// TravelDestination travelDestination = TravelDestination(
// city: doc["city"],
// placeId: doc["hotelId"],
// placeName: doc["hotelName"],
// mainPhotoUrl: doc["mainPhotoUrl"],
// reviewScore: doc["reviewScore"],
// reviewScoreWord: doc["reviewScoreWord"],
// reviewText: doc["reviewText"],
// description: doc["description"],
// coordinates: doc["coordinates"],
// checkin: doc["checkin"],
// checkout: doc["checkout"],
// address: doc["address"],
// url: doc["url"],
// introduction: doc["introduction"]);
//
// print("placeName:${travelDestination.placeName}, ");
//
// print("placeName:${travelDestination.placeName}");
// places.add(travelDestination);
// });
// });
// } catch (e) {
// print("Data Fetch Error:$e");
// } finally {
// return places;
// }
// }
