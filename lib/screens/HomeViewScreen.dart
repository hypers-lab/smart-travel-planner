import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/util/const.dart';
import '../widgets/horizontal_place_item.dart';
import '../widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFetching = false;
  bool isFetchingHistory = false;
  List<PlaceInformation> nearByPlaces = [];
  List<PlaceInformation> recentPlaces = [];

  //initial location
  late LatLng _center = LatLng(0, 0);

  late final Geolocator _geolocator = Geolocator();

  var googlePlace = GooglePlace(GOOGLE_API_KEY);

  // For storing the current position
  late Position _currentPosition = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  @override
  void initState() {
    super.initState();
    getRecentPlacesData();
    getNearbyPlacesData();
  }

  //get nearby places
  void getNearbyPlacesData() async {
    setState(() {
      isFetching = true;
    });

    await _getCurrentLocation();

    var result = await googlePlace.search.getNearBySearch(
      Location(lat: _currentPosition.latitude, lng: _currentPosition.longitude),
      3500,
    );

    var nearBySearrchResults = result!.results;

    if (nearBySearrchResults != null) {
      for (var placeInfo in nearBySearrchResults) {
        if (placeInfo != null) {
          var businessStatus = placeInfo.businessStatus;
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
          var placeId = placeInfo.id;
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
              address: address.toString());

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

          nearByPlaces.add(placeInformation);
        }
      }
    }

    setState(() {
      isFetching = false;
    });
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;
      print('Current Location: $_currentPosition');
    }).catchError((e) {
      print(e);
    });
  }

  //get user recently travelled places
  Future<void> getRecentPlacesData() async {
    setState(() {
      isFetchingHistory = true;
    });

    await FirebaseFirestore.instance
        .collection("visitedPlaces")
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc["placeName"]);
        TravelDestination travelDestination = TravelDestination(
            businessStatus: doc["businessStatus"],
            placeId: doc["placeId"],
            placeName: doc["placeName"],
            photoReference: doc["photoReference"],
            rating: doc["rating"],
            userRatingsTotal: doc["userRatingsTotal"],
            latitude: doc["latitude"],
            longitude: doc["longitude"],
            description: doc["description"],
            openStatus: doc["openStatus"],
            address: doc["address"]);

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

        recentPlaces.add(placeInformation);

        setState(() {
          isFetchingHistory = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Text(
              "Where are you \ngoing?",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Recently Visited Places",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isFetchingHistory
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildHorizontalList(context),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Places NearBy",
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
              : buildVerticalList(context),
        ],
      ),
    );
  }

  buildHorizontalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: recentPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = recentPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildVerticalList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: nearByPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByPlaces[index];
          return VerticalPlaceItem(place);
        },
      ),
    );
  }
}
