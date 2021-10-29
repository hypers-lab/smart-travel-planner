import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/appBrain/preference.dart';
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
  bool isFetchingPreferences = false;

  List<PlaceInformation> nearByPlaces = [];
  List<PlaceInformation> recentPlaces = [];
  List<PlaceInformation> preferredPlaces = [];

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
    getUserPreferedPlacesData();
  }

  // Future<void> executePipeline() async {
  //   await getRecentPlacesData();
  //   await getNearbyPlacesData();
  // }

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

    if (result != null) {
      var nearBySearchResults = result.results;

      if (nearBySearchResults != null) {
        for (var placeInfo in nearBySearchResults) {
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
          //print(placeName);
          var openingHours = placeInfo.openingHours;
          var openStatus;
          if (openingHours != null) {
            openStatus = openingHours.openNow;
          }
          var placeId = placeInfo.placeId;
          //print(placeId);
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
          // Uint8List image =
          //     (await rootBundle.load('assets/default_place_image.jpg'))
          //         .buffer
          //         .asUint8List();

          var image = await this
              .googlePlace
              .photos
              .get(travelDestination.photoReference, 0, 400);
          if (image == null) {
            image = (await rootBundle.load('assets/default_place_image.jpg'))
                .buffer
                .asUint8List();
          }

          PlaceInformation placeInformation =
              PlaceInformation(travelDestination, image);

          nearByPlaces.add(placeInformation);
          setState(() {
            isFetching = false;
          });
        }
      }
    }

    if (this.mounted) {
      setState(() {
        isFetching = false;
      });
    }
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;
      //print('Current Location: $_currentPosition');
    }).catchError((e) {
      print(e);
    });
  }

  //get user recently travelled places
  void getRecentPlacesData() async {
    setState(() {
      isFetchingHistory = true;
    });

    final String uid = TravelDestination.getCurrentUserId();

    await FirebaseFirestore.instance
        .collection("visitedPlaces")
        .where("userId", isEqualTo: uid)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length != 0) {
        querySnapshot.docs.forEach((doc) async {
          print(doc["placeId"]);

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
            address: doc["address"],
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

          if (this.mounted) {
            setState(() {
              isFetchingHistory = false;
            });
          }
        });
      }
    });
  }

  //get travelled places based on user preferences
  Future<void> getUserPreferedPlacesData() async {
    setState(() {
      isFetchingPreferences = true;
    });

    final String uid = TravelDestination.getCurrentUserId();

    List<String> placeTypes = [];
    List<List> placeAreas = [];

    await FirebaseFirestore.instance
        .collection('userPreferences')
        .doc(uid)
        .get()
        .then((value) async {
      UserPreference userPreference = UserPreference(
          preferredTypes: value.get('preferredTypes'),
          preferrredAreas: value.get('preferredAreas'));

      for (int placeTypeIndex in userPreference.preferredTypes) {
        await FirebaseFirestore.instance
            .collection("placeTypes")
            .where("typeId", isEqualTo: placeTypeIndex)
            .limit(1)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            placeTypes.add(result.data()['typeName']);
            print('placeType: ${result.data()['typeName']}');
          });
        });
      }

      for (int placeAreaIndex in userPreference.preferrredAreas) {
        await FirebaseFirestore.instance
            .collection("preferredAreas")
            .where("area_id", isEqualTo: placeAreaIndex)
            .limit(1)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            placeAreas
                .add([result.data()['latitude'], result.data()['longitude']]);
          });
        });
      }

      for (var area in placeAreas) {
        double plat = area[0];
        double plong = area[1];

        for (var ptype in placeTypes) {
          //fetch data from Places API
          var result = await googlePlace.search.getNearBySearch(
              Location(lat: plat, lng: plong), 1500,
              type: ptype);

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

                preferredPlaces.add(placeInformation);
              }
            }
          }
        }
      }

      if (this.mounted) {
        setState(() {
          isFetchingPreferences = false;
        });
      }
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
              : recentPlaces.length > 0
                  ? buildHorizontalList(context)
                  : Center(
                      child: Text(
                        "No visited places",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Your Prefernces May Be...",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isFetchingPreferences
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildHorizontalPreferList(context),
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

  buildHorizontalPreferList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: preferredPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = preferredPlaces[index];
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


// UserPreference userPreference = UserPreference(
//           preferredTypes: value.get('preferredTypes'),
//           preferrredAreas: value.get('preferredAreas'));

//       for (int placeTypeIndex in userPreference.preferredTypes) {
//         await FirebaseFirestore.instance
//             .collection("placeTypes")
//             .where("typeId", isEqualTo: placeTypeIndex)
//             .limit(1)
//             .get()
//             .then((value) {
//           value.docs.forEach((result) {
//             placeTypes.add(result.data()['typeName']);
//             print('placeType: ${result.data()['typeName']}');
//           });
//         });
//       }

//       for (int placeAreaIndex in userPreference.preferrredAreas) {
//         await FirebaseFirestore.instance
//             .collection("preferredAreas")
//             .where("area_id", isEqualTo: placeAreaIndex)
//             .limit(1)
//             .get()
//             .then((value) {
//           value.docs.forEach((result) {
//             placeAreas
//                 .add([result.data()['latitude'], result.data()['longitude']]);
//           });
//         });
//       }

//       for (var area in placeAreas) {
//         double plat = area[0];
//         double plong = area[1];

//         for (var ptype in placeTypes) {
//           //fetch data from Places API
//           var result = await googlePlace.search.getNearBySearch(
//               Location(lat: plat, lng: plong), 1500,
//               type: ptype);

//           var nearBySearrchResults = result!.results;

//           if (nearBySearrchResults != null) {
//             for (var placeInfo in nearBySearrchResults) {
//               if (placeInfo != null) {
//                 var businessStatus = placeInfo.businessStatus;
//                 var location;
//                 var longitude;
//                 var latitude;
//                 var geometry = placeInfo.geometry;
//                 if (geometry != null) {
//                   location = geometry.location;
//                   if (location != null) {
//                     latitude = location.lat;
//                     longitude = location.lng;
//                   }
//                 }

//                 var placeName = placeInfo.name;
//                 var openingHours = placeInfo.openingHours;
//                 var openStatus;
//                 if (openingHours != null) {
//                   openStatus = openingHours.openNow;
//                 }
//                 var placeId = placeInfo.id;
//                 var plusCode = placeInfo.plusCode;
//                 var address;
//                 if (plusCode != null) {
//                   address = plusCode.compoundCode;
//                 }
//                 var rating = placeInfo.rating;
//                 var userRatingsTotal = placeInfo.userRatingsTotal;
//                 var photos = placeInfo.photos;
//                 var photoReference;
//                 if (photos != null) {
//                   photoReference = photos[0].photoReference;
//                 }
//                 var description = placeInfo.vicinity;

//                 TravelDestination travelDestination = TravelDestination(
//                     businessStatus: businessStatus.toString(),
//                     placeId: placeId.toString(),
//                     placeName: placeName.toString(),
//                     photoReference: photoReference.toString(),
//                     rating: rating.toString(),
//                     userRatingsTotal: userRatingsTotal.toString(),
//                     latitude: latitude,
//                     longitude: longitude,
//                     description: description.toString(),
//                     openStatus: openStatus.toString(),
//                     address: address.toString(),
//                     weather: []);

//                 //default image
//                 Uint8List image =
//                     (await rootBundle.load('assets/default_place_image.jpg'))
//                         .buffer
//                         .asUint8List();

//                 var imageResult = await this
//                     .googlePlace
//                     .photos
//                     .get(travelDestination.photoReference, 0, 400);
//                 if (imageResult != null) {
//                   image = imageResult;
//                 }

//                 PlaceInformation placeInformation =
//                     PlaceInformation(travelDestination, image);

//                 preferredPlaces.add(placeInformation);
//               }
//             }
//           }
//         }
//       }

//       if (this.mounted) {
//         setState(() {
//           isFetchingPreferences = false;
//         });
//       }