import 'dart:typed_data';

import 'package:smart_travel_planner/util/tripsdata.dart';

class Trip {
  Trip(
      {required this.documentID,
      required this.tripName,
      required this.places,
      required this.image,
      required this.date,
      required this.userId,
      required this.status});

  String documentID;
  String tripName;
  List<dynamic> places;
  String image;
  DateTime date;
  String userId;
  int status;

  static List<Trip> getTripDetailsDummy() {
    List<Trip> trips = [];
    try {
      tripsdata.forEach((doc) {
        Trip trip = Trip(
            documentID: doc.reference.id,
            tripName: doc["tripName"],
            places: doc["places"],
            date: doc["date"],
            image: doc["image"],
            status: doc["status"],
            userId: doc["userId"]);
        trips.add(trip);
        print(trip);
      });
    } catch (e) {
      print("Data Fetch Error:$e");
    }
    return trips;
  }
}
