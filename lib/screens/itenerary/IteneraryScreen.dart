import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/appBrain/TripInformation.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/MainScreen.dart';
import 'package:smart_travel_planner/screens/itenerary/SearchScreen.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/horizontal_trip_item.dart';
import 'package:smart_travel_planner/widgets/verticle_trip_item.dart';
import 'package:google_place/google_place.dart';

class IteneraryScreen extends StatefulWidget {
  const IteneraryScreen({Key? key}) : super(key: key);

  @override
  _IteneraryScreenState createState() => _IteneraryScreenState();
}

class _IteneraryScreenState extends State<IteneraryScreen> {
  bool isFetching = true;
  bool isRecommendFetching = true;
  var googlePlace = GooglePlace(GOOGLE_API_KEY);
  //final List<Trip> _trips = Trip.getTripDetailsDummy();
  List<TripInformation> trips = [];
  List<TripInformation> recomendedTrips = [];
  late ScrollController _tripScrollController;
  int loadMoreMsgs = 25; // at first it will load only 25
  int a = 50;

  @override
  void initState() {
    super.initState();
    getGroupsData();
    getRecommendedPlaces();
    _tripScrollController = ScrollController()
      ..addListener(() {
        if (_tripScrollController.position.atEdge) {
          if (_tripScrollController.position.pixels != 0)
            setState(() {
              loadMoreMsgs = loadMoreMsgs + a;
            });
        }
      });
  }

  getRecommendedPlaces() async {
    final String uid = TravelDestination.getCurrentUserId();
    await FirebaseFirestore.instance
        .collection("userPreferences")
        .doc(uid)
        .get()
        .then((snapshot) async {
      //print(snapshot["preferredAreas"]);
      if (snapshot["preferredAreas"].length > 0) {
        for (int areaId in snapshot["preferredAreas"]) {
          List<PlaceInformation> recomendedDoPlaces = [];
          List<PlaceInformation> recomendedEatPlaces = [];
          List<PlaceInformation> recomendedStayPlaces = [];
          //print(areaId);
          await FirebaseFirestore.instance
              .collection("preferredAreas")
              .where("area_id", isEqualTo: areaId)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.length > 0) {
              querySnapshot.docs.forEach((doc) async {
                // ================ Do ================
                //print(doc['latitude']);
                var doResult = await googlePlace.search.getNearBySearch(
                  Location(lat: doc['latitude'], lng: doc["longitude"]),
                  3500,
                  type: "movie_theater|museum|tourist_attraction",
                );
                //print(doResult);
                if (doResult != null) {
                  var nearBySearrchResults = doResult.results;
                  //print(nearBySearrchResults);
                  if (nearBySearrchResults != null) {
                    for (var placeInfo in nearBySearrchResults) {
                      // ignore: unnecessary_null_comparison
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
                        var placeId = placeInfo.placeId;
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
                          latitude: latitude!,
                          longitude: longitude!,
                          description: description.toString(),
                          openStatus: openStatus.toString(),
                          address: address.toString(),
                        );

                        //default image
                        Uint8List image = (await rootBundle
                                .load('assets/default_place_image.jpg'))
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

                        recomendedDoPlaces.add(placeInformation);
                      }
                    }
                  }
                }

                // ================ Eat ================
                var eatResult = await googlePlace.search.getNearBySearch(
                  Location(lat: doc['latitude'], lng: doc["longitude"]),
                  3500,
                  type: "restaurant",
                );
                //print(doResult);
                if (eatResult != null) {
                  var nearBySearrchResults = eatResult.results;
                  //print(nearBySearrchResults);
                  if (nearBySearrchResults != null) {
                    for (var placeInfo in nearBySearrchResults) {
                      // ignore: unnecessary_null_comparison
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
                        var placeId = placeInfo.placeId;
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
                          latitude: latitude!,
                          longitude: longitude!,
                          description: description.toString(),
                          openStatus: openStatus.toString(),
                          address: address.toString(),
                        );

                        //default image
                        Uint8List image = (await rootBundle
                                .load('assets/default_place_image.jpg'))
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

                        recomendedEatPlaces.add(placeInformation);
                      }
                    }
                  }
                }

                // ================ Stay ================
                var stayResult = await googlePlace.search.getNearBySearch(
                  Location(lat: doc['latitude'], lng: doc["longitude"]),
                  3500,
                  type: "lodging",
                );
                //print(doResult);
                if (stayResult != null) {
                  var nearBySearrchResults = stayResult.results;
                  //print(nearBySearrchResults);
                  if (nearBySearrchResults != null) {
                    for (var placeInfo in nearBySearrchResults) {
                      // ignore: unnecessary_null_comparison
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
                        var placeId = placeInfo.placeId;
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
                          latitude: latitude!,
                          longitude: longitude!,
                          description: description.toString(),
                          openStatus: openStatus.toString(),
                          address: address.toString(),
                        );

                        //default image
                        Uint8List image = (await rootBundle
                                .load('assets/default_place_image.jpg'))
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

                        recomendedStayPlaces.add(placeInformation);
                      }
                    }
                  }
                }
                // ===== Create recommended trips ========
                String tripName = doc["area_name"];
                DateTime now = DateTime.now();
                String userdId = TravelDestination.getCurrentUserId();
                List<dynamic> places = [];

                if (recomendedDoPlaces.length > 0 &&
                    recomendedEatPlaces.length > 0 &&
                    recomendedStayPlaces.length > 0) {
                  //eat - place 1
                  PlaceInformation place1 = getRandomPlace(recomendedEatPlaces);
                  places.add(place1.travelDestination.placeId);

                  //do - place 2
                  PlaceInformation place2 = getRandomPlace(recomendedDoPlaces);
                  places.add(place2.travelDestination.placeId);

                  // eat - place 3
                  PlaceInformation place3 = getRandomPlace(recomendedEatPlaces);
                  places.add(place3.travelDestination.placeId);

                  // do - place 4
                  PlaceInformation place4 = getRandomPlace(recomendedDoPlaces);
                  places.add(place4.travelDestination.placeId);

                  // do - place 5
                  PlaceInformation place5 = getRandomPlace(recomendedDoPlaces);
                  places.add(place5.travelDestination.placeId);

                  // eat - place 6
                  PlaceInformation place6 = getRandomPlace(recomendedEatPlaces);
                  places.add(place6.travelDestination.placeId);

                  // stay = place 7
                  PlaceInformation place7 =
                      getRandomPlace(recomendedStayPlaces);
                  places.add(place7.travelDestination.placeId);

                  Trip trip = Trip(
                      documentID: "",
                      tripName: tripName,
                      places: places,
                      date: now,
                      image: place6.travelDestination.photoReference,
                      status: 0,
                      userId: userdId);

                  //default image
                  Uint8List image =
                      (await rootBundle.load('assets/default_place_image.jpg'))
                          .buffer
                          .asUint8List();

                  var imageResult = await this
                      .googlePlace
                      .photos
                      .get(place6.travelDestination.photoReference, 0, 400);
                  if (imageResult != null) {
                    image = imageResult;
                  }

                  TripInformation tripInformation =
                      TripInformation(trip, image);

                  recomendedTrips.add(tripInformation);

                  setState(() {
                    isRecommendFetching = false;
                  });
                }
              });
            }
          });
        }
      }
    });
  }

  PlaceInformation getRandomPlace<PlaceInformation>(
      List<PlaceInformation> places) {
    final random = new Random();
    var i = random.nextInt(places.length);
    PlaceInformation place = places[i];
    return place;
  }

  getGroupsData() async {
    await FirebaseFirestore.instance
        .collection("trips")
        .orderBy('date')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((doc) async {
          //print(doc["places"]);
          //print(doc.reference.id);

          Trip trip = Trip(
              documentID: doc.reference.id, // <-- Document ID
              tripName: doc["tripName"],
              places: doc["places"],
              date: doc["date"].toDate(),
              image: doc["image"],
              status: doc["status"],
              userId: doc["userId"]);

          //default image
          Uint8List image =
              (await rootBundle.load('assets/default_place_image.jpg'))
                  .buffer
                  .asUint8List();

          var imageResult =
              await this.googlePlace.photos.get(doc["image"], 0, 400);
          if (imageResult != null) {
            image = imageResult;
          }

          TripInformation tripInformation = TripInformation(trip, image);

          trips.add(tripInformation);

          setState(() {
            isFetching = false;
          });
        });
      } else {
        setState(() {
          isFetching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline_outlined),
            color: Colors.blue,
            onPressed: _addTripPlan,
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.amber,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Recommended Trips",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isRecommendFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : recomendedTrips.length > 0
                  ? buildHorizontalList(context)
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Oops! No Recomended Trip Plans!",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Planned Trips",
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
              : trips.length > 0
                  ? buildVerticalList()
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Oops! No Trip Plans!",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  buildHorizontalList(BuildContext context) {
    final ids = Set();
    trips.retainWhere((x) => ids.add(x.trip.tripName));
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: recomendedTrips.length,
        itemBuilder: (BuildContext context, int index) {
          TripInformation tripInformation =
              recomendedTrips.reversed.toList()[index];
          return HorizontalTripItem(tripInformation);
        },
      ),
    );
  }

  buildVerticalList() {
    final ids = Set();
    trips.retainWhere((x) => ids.add(x.trip.tripName));
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: trips.length,
        itemBuilder: (BuildContext context, int index) {
          TripInformation tripInformation = trips.reversed.toList()[index];
          return VerticalTripItem(tripInformation);
        },
      ),
    );
  }

  var tripNameController = TextEditingController();
  Future<void> _addTripPlan() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Trip Plan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: tripNameController,
                  decoration: InputDecoration(hintText: 'Trip Name'),
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
                // Send them to your email maybe?
                var tripName = tripNameController.text;
                DateTime now = DateTime.now();
                String userdId = TravelDestination.getCurrentUserId();

                //adding to firebase
                CollectionReference trips =
                    FirebaseFirestore.instance.collection('trips');
                trips.add({
                  'tripName': tripName,
                  'date': now,
                  'status': 0,
                  'userId': userdId,
                  'image': 'assets/default_place_image.jpg',
                  'places': []
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Trip added successfully."),
                  ),
                );
                getGroupsData();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
