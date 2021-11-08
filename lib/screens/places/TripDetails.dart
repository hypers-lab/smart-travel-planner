import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/itenerary/IteneraryScreen.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/vertical_place_item.dart';
import '../../widgets/vertical_place_item.dart';
import 'package:http/http.dart' as http;

class TripDetails extends StatefulWidget {
  static const String id = 'tripDetails';

  TripDetails({required this.trip});

  final Trip trip;

  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  late Trip trip = widget.trip;
  bool isFetching = false;
  List<PlaceInformation> places = [];
  bool isFinished = false;
  bool isWeather = false;
  CollectionReference tripsRef = FirebaseFirestore.instance.collection('trips');
  var googlePlace = GooglePlace(GOOGLE_API_KEY);
  String news = "";

  @override
  void initState() {
    super.initState();
    getPlacesData(trip);
  }

  getWeatherDetails() async {
    for (int i = 0; i < places.length; i++) {
      PlaceInformation place = places[i];
      String urlName = "https://api.openweathermap.org/data/2.5/weather?lat=" +
          place.travelDestination.latitude.toString() +
          "&lon=" +
          place.travelDestination.longitude.toString() +
          "&appid=a47323fec912e74eeecd6507fb739b9d";
      var url = Uri.parse(urlName);
      var response = await http.get(url);

      var weatherDetails = [];
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        weatherDetails = jsonResponse['weather'].toSet().toList();
        //print(weatherDetails);
      }
      if (weatherDetails[0]['main'].toString() == "Rain") {
        news += place.travelDestination.placeName +
            " - " +
            "Raining there. Its difficult to visit. Better to change this place" +
            "\n";
      }
      setState(() {
        isWeather = true;
      });
    }
  }

  getTrip() {
    FirebaseFirestore.instance
        .collection("trips")
        .doc(trip.documentID)
        .get()
        .then((snapshot) {
      Trip tripNew = Trip(
          documentID: snapshot.reference.id, // <-- Document ID
          tripName: snapshot["tripName"],
          places: snapshot["places"],
          date: snapshot["date"].toDate(),
          image: snapshot["image"],
          status: snapshot["status"],
          userId: snapshot["userId"]);

      setState(() {
        trip = tripNew;
      });
    });
  }

  getPlacesData(trip) async {
    setState(() {
      isFetching = true;
    });
    //print(trip.places);

    for (String placeId in trip.places) {
      var result = await this.googlePlace.details.get(placeId);
      if (result != null && result.result != null && mounted) {
        var placeInfo = result.result;

        var businessStatus = placeInfo!.businessStatus;
        var location;
        var longitude;
        var latitude;
        var geometry = placeInfo.geometry;
        if (geometry != null) {
          location = geometry.location;
          if (location != null) {
            latitude = location.lat;
            longitude = location.lng;
          }
        }

        var placeName = placeInfo.name;
        var openingHours = placeInfo.openingHours;
        var openStatus;
        if (openingHours != null) {
          openStatus = openingHours.openNow;
        }
        var plusCode = placeInfo.plusCode;
        var address;
        if (plusCode != null) {
          address = plusCode.compoundCode;
        }
        var rating = placeInfo.rating;
        var userRatingsTotal = placeInfo.userRatingsTotal;
        var photos = placeInfo.photos;
        var photoReference;
        if (photos != null) {
          photoReference = photos[0].photoReference;
        }
        var description = placeInfo.vicinity;

        TravelDestination travelDestination = TravelDestination(
          businessStatus: businessStatus.toString(),
          placeId: placeId.toString(),
          placeName: placeName.toString(),
          photoReference: photoReference.toString(),
          rating: rating.toString(),
          userRatingsTotal: userRatingsTotal.toString(),
          latitude: latitude,
          longitude: longitude,
          description: description.toString(),
          openStatus: openStatus.toString(),
          address: address.toString(),
        );

        //default image
        Uint8List image =
            (await rootBundle.load('assets/default_place_image.jpg'))
                .buffer
                .asUint8List();

        var imageResult = await this
            .googlePlace
            .photos
            .get(travelDestination.photoReference, 0, 400);
        if (imageResult != null) {
          image = imageResult;
        }

        PlaceInformation placeInformation =
            PlaceInformation(travelDestination, image);

        places.add(placeInformation);
      }
    }
    setState(() {
      isFetching = false;
      getWeatherDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IteneraryScreen(),
              ),
            ),
          ),
          actions: <Widget>[
            trip.status == 1
                ? IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    onPressed: () {
                      tripsRef
                          .doc(trip.documentID)
                          .update({'status': 0})
                          .then((value) => print("Trip Updated"))
                          .catchError((error) =>
                              print("Failed to update trip: $error"));

                      getTrip();
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    onPressed: () {
                      tripsRef
                          .doc(trip.documentID)
                          .update({'status': 1})
                          .then((value) => print("Trip Updated"))
                          .catchError((error) =>
                              print("Failed to update trip: $error"));

                      getTrip();
                    },
                  ),
            Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 24.0,
                  ),
                  onPressed: () {
                    _deleteTripPlan(trip.documentID);
                  },
                )),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Text(
                trip.tripName,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            isWeather
                ? news.length > 0
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Text(
                          news,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Text(
                          "No latest news!",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Text(
                "Places",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            isFetching
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : places.length > 0
                    ? buildVerticalList()
                    : Center(
                        child: Text(
                          "No visited places",
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  buildVerticalList() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = places[index];
          return VerticalPlaceItem(place);
        },
      ),
    );
  }

  Future<void> _deleteTripPlan(documentId) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Trip Plan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Do you want to delete " + trip.tripName + "?",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                tripsRef
                    .doc(documentId)
                    .delete()
                    .then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IteneraryScreen(),
                        ),
                      ),
                    )
                    .catchError(
                        (error) => print("Failed to delete trip: $error"));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
