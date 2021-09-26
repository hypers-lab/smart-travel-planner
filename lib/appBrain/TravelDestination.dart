import 'package:cloud_firestore/cloud_firestore.dart';
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

          //print("placeName:${travelDestination.placeName}, ");

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
    //NEED: change this function to return a list of "TravelDestination" objects with suggested places from model
    //print(hotelId);

    List<TravelDestination> suggestPlaces = [];
    try {
      String urlName =
          'https://sep-recommender.herokuapp.com/recommend?hotel_id=' +
              hotelId.toString();
      var url = Uri.parse(urlName);
      print(urlName);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var suggestPlacesIds = jsonResponse['recommended_hotels'];
        //print(suggestPlacesIds);
        for (int i = 0; i < 10; i++) {
          FirebaseFirestore.instance
              .collection("hotels")
              .doc(suggestPlacesIds[i].toString())
              .get()
              .then((doc) {
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

            print(doc['hotelId']);
            suggestPlaces.add(travelDestination);
          });
        }
        //NEED: create objects from ids and store into an array
        //print('Suggested Hotels array: $suggestPlacesIds.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print("Error: $e");
    }
    return suggestPlaces; //Uncomment when function complete
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

        //print("placeName:${travelDestination.placeName}, ");

        places.add(travelDestination);
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    }
    return places;
  }
}
