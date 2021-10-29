import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart' as gp;
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/MainScreen.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';

class DetailsPageScreen extends StatefulWidget {
  static const String id = 'itenerary';

  DetailsPageScreen({required this.placeId, required this.placeName});

  final String placeId;
  final String placeName;

  @override
  DetailsPageScreenState createState() => new DetailsPageScreenState();
}

class DetailsPageScreenState extends State<DetailsPageScreen> {
  late String placeId = widget.placeId;
  late String placeName = widget.placeName;

  bool isDoFetching = true;
  bool isEatFetching = true;
  bool isStayFetching = true;
  List<PlaceInformation> nearByDoPlaces = [];
  List<PlaceInformation> nearByEatPlaces = [];
  List<PlaceInformation> nearByStayPlaces = [];
  var googlePlace = gp.GooglePlace(GOOGLE_API_KEY);
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    executePipeline();
  }

  Future<void> executePipeline() async {
    await getNearbyDoPlacesData(placeId);
    await getNearbyEatPlacesData(placeId);
    await getNearbyStayPlacesData(placeId);
  }

  //get nearby do places
  Future<void> getNearbyDoPlacesData(placeId) async {
    setState(() {
      isDoFetching = true;
    });

    var placeResult = await this.googlePlace.details.get(placeId);
    if (placeResult != null && placeResult.result != null && mounted) {
      final latitude = placeResult.result!.geometry!.location!.lat;
      final longitude = placeResult.result!.geometry!.location!.lng;

      var result = await googlePlace.search.getNearBySearch(
        gp.Location(lat: latitude, lng: longitude),
        1500,
        type:
            "library|beauty_salon|clothing_store|hair_care|home_goods_store|movie_theater|museum|park|shopping_mall|spa|supermarket|tourist_attraction",
      );

      if (result != null) {
        var nearBySearrchResults = result.results;

        if (nearBySearrchResults != null) {
          for (var placeInfo in nearBySearrchResults) {
            // ignore: unnecessary_null_comparison
            if (placeInfo != null) {
              var businessStatus = placeInfo.businessStatus;
              // var location;
              // var longitude;
              // var latitude;
              // var geometry = placeInfo.geometry;

              // if (geometry != null) {
              //   location = geometry.location;
              //   if (location != null) {
              //     latitude = location.lat;
              //     longitude = location.lng;
              //   }
              // }
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
                latitude: latitude!,
                longitude: longitude!,
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

              nearByDoPlaces.add(placeInformation);
            }
          }
        }
      }
    }
    setState(() {
      isDoFetching = false;
    });
  }

  //get nearby eat places
  Future<void> getNearbyEatPlacesData(placeId) async {
    setState(() {
      isEatFetching = true;
    });

    var placeResult = await this.googlePlace.details.get(placeId);
    if (placeResult != null && placeResult.result != null && mounted) {
      final latitude = placeResult.result!.geometry!.location!.lat;
      final longitude = placeResult.result!.geometry!.location!.lng;

      var result = await googlePlace.search.getNearBySearch(
        gp.Location(lat: latitude, lng: longitude),
        1500,
        type: "bar|cafe|liquor_store|meal_delivery|meal_takeaway|restaurant",
      );

      if (result != null) {
        var nearBySearrchResults = result.results;

        if (nearBySearrchResults != null) {
          for (var placeInfo in nearBySearrchResults) {
            // ignore: unnecessary_null_comparison
            if (placeInfo != null) {
              var businessStatus = placeInfo.businessStatus;
              // var location;
              // var longitude;
              // var latitude;
              // var geometry = placeInfo.geometry;

              // if (geometry != null) {
              //   location = geometry.location;
              //   if (location != null) {
              //     latitude = location.lat;
              //     longitude = location.lng;
              //   }
              // }
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
                latitude: latitude!,
                longitude: longitude!,
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

              nearByEatPlaces.add(placeInformation);
            }
          }
        }
      }
    }
    setState(() {
      isEatFetching = false;
    });
  }

  //get nearby eat places
  Future<void> getNearbyStayPlacesData(placeId) async {
    setState(() {
      isStayFetching = true;
    });

    var placeResult = await this.googlePlace.details.get(placeId);
    if (placeResult != null && placeResult.result != null && mounted) {
      final latitude = placeResult.result!.geometry!.location!.lat;
      final longitude = placeResult.result!.geometry!.location!.lng;

      var result = await googlePlace.search.getNearBySearch(
        gp.Location(lat: latitude, lng: longitude),
        1500,
        type: "lodging",
      );

      if (result != null) {
        var nearBySearrchResults = result.results;

        if (nearBySearrchResults != null) {
          for (var placeInfo in nearBySearrchResults) {
            // ignore: unnecessary_null_comparison
            if (placeInfo != null) {
              var businessStatus = placeInfo.businessStatus;
              // var location;
              // var longitude;
              // var latitude;
              // var geometry = placeInfo.geometry;

              // if (geometry != null) {
              //   location = geometry.location;
              //   if (location != null) {
              //     latitude = location.lat;
              //     longitude = location.lng;
              //   }
              // }
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
                latitude: latitude!,
                longitude: longitude!,
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

              nearByStayPlaces.add(placeInformation);
            }
          }
        }
      }
    }
    setState(() {
      isStayFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.login,
              color: Colors.amber,
              size: 24.0,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Text(
              "Travel Recomendations",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              placeName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Do",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isDoFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : nearByDoPlaces.length > 0
                  ? buildHorizontalDoList(context)
                  : Center(
                      child: Text(
                        "No Places",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Eat",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isEatFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : nearByEatPlaces.length > 0
                  ? buildHorizontalEatList(context)
                  : Center(
                      child: Text(
                        "No Places",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Stay",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isStayFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : nearByStayPlaces.length > 0
                  ? buildHorizontalStayList(context)
                  : Center(
                      child: Text(
                        "No Places",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  buildHorizontalDoList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: nearByDoPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByDoPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildHorizontalEatList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: nearByEatPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByEatPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildHorizontalStayList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: nearByStayPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByStayPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }
}
