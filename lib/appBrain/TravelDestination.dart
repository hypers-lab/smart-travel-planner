import 'package:cloud_firestore/cloud_firestore.dart';

String collectionName = "hotels";

class TravelDestination {
  TravelDestination(
      {required this.accommodationTypeName,
      required this.city,
      required this.placeId,
      required this.placeName,
      required this.mainPhotoUrl,
      required this.reviewScore,
      required this.reviewScoreWord,
      this.description,
      this.latitude,
      this.longitude,
      this.checkout,
      this.checkin,
      this.address,
      this.district,
      this.url,
      this.maxPhotoUrl,
      this.mapPreviewUrl});

  String accommodationTypeName;
  String city;
  int placeId;
  String placeName;
  String mainPhotoUrl;
  double reviewScore;
  String reviewScoreWord;
  String? description;
  double? latitude;
  double? longitude;
  Map? checkout;
  Map? checkin;
  String? address;
  String? district;
  String? url;
  String? maxPhotoUrl;
  String? mapPreviewUrl;

  static List<TravelDestination> getPlacesDetails() {
    List<TravelDestination> places = [];
    try {
      FirebaseFirestore.instance
          .collection(collectionName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          TravelDestination travelDestination = TravelDestination(
              accommodationTypeName: doc["accommodationTypeName"],
              city: doc["city"],
              placeId: doc["hotelId"],
              placeName: doc["hotelName"],
              mainPhotoUrl: doc["mainPhotoUrl"],
              reviewScore: doc["reviewScore"],
              reviewScoreWord: doc["reviewScoreWord"]);
          print("placeName:${travelDestination.placeName}, "
              "accommodationTypeName:${travelDestination.accommodationTypeName}, "
              "city:${travelDestination.city}, "
              "placeId:${travelDestination.placeId}, "
              "mainPhotoUrl:${travelDestination.mainPhotoUrl}, "
              "reviewScore:${travelDestination.reviewScore}, "
              "reviewScoreWord:${travelDestination.reviewScoreWord}");
          places.add(travelDestination);
        });
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    } finally {
      return places;
    }
  }

  void retrieveMoreDetails() {
    FirebaseFirestore.instance
        .collection(collectionName)
        .where("hotelId", isEqualTo: this.placeId)
        .get()
        .then((value) {
      var place = value.docs[0];
      this.description = place["description"];
      this.latitude = place["latitude"];
      this.longitude = place["longitude"];
      this.longitude = place["checkout"];
      this.longitude = place["checkin"];
      this.longitude = place["address"];
      this.longitude = place["district"];
      this.longitude = place["url"];
      this.longitude = place["maxPhotoUrl"];
      this.longitude = place["mapPreviewUrl"];
    });
  }
}

// FirebaseFirestore.instance
//     .collection(collectionName)
// .get()
//     .then((QuerySnapshot querySnapshot) {
// querySnapshot.docs.forEach((doc) {
// var travelDestination = TravelDestination(
// accommodationTypeName:
// doc.data().toString().contains('accommodationTypeName')
// ? doc.get('accommodationTypeName')
//     : '',
// city:
// doc.data().toString().contains('city') ? doc.get('city') : '',
// placeId: doc.data().toString().contains('hotelId')
// ? doc.get('hotelId')
//     : '',
// placeName: doc.data().toString().contains('hotelName')
// ? doc.get('hotelName')
//     : '',
// mainPhotoUrl: doc.data().toString().contains('mainPhotoUrl')
// ? doc.get('mainPhotoUrl')
//     : '',
// reviewScore: doc.data().toString().contains('reviewScore')
// ? doc.get('reviewScore')
//     : '',
// reviewScoreWord: doc.data().toString().contains('reviewScoreWord')
// ? doc.get('reviewScoreWord')
//     : '');
// places.add(travelDestination);
// print("placeName:${travelDestination.placeName}");
// });
// });

// FirebaseFirestore.instance
//     .collection(collectionName)
// .get()
//     .then((QuerySnapshot querySnapshot) {
// querySnapshot.docs.forEach((doc) {
// TravelDestination travelDestination = TravelDestination(
// accommodationTypeName: doc["accommodationTypeName"],
// city: doc["city"],
// placeId: doc["hotelId"],
// placeName: doc["hotelName"],
// mainPhotoUrl: doc["mainPhotoUrl"],
// reviewScore: doc["reviewScore"],
// reviewScoreWord: doc["reviewScoreWord"]);
// places.add(travelDestination);
// print("placeName:${travelDestination.placeName}");
// });
// });
