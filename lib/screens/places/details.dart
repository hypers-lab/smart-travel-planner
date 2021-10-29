import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/places/MapViewerScreen.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'package:http/http.dart' as http;
import 'package:smart_travel_planner/widgets/trip_select_popup.dart';

class Details extends StatefulWidget {
  static const String id = 'details';

  Details({required this.place});

  final PlaceInformation place;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late PlaceInformation place = widget.place;

  //Dialog box for Review the place
  void _showRatingAppDialog() {
    Navigator.pop(context);
    final _ratingDialog = RatingDialog(
      title: Text('Rate Travel Place'),
      message: Text('Rating the place and tell others what you think.'
          ' Add a comment if you want.'),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');
        //add rating to system
        place.travelDestination
            .addReviewComments(response.rating.toDouble(), response.comment);
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  //Dialog box for marking the place as visited
  _showVistedMarkingDialog(context, PlaceInformation placeId, String showText) {
    Alert(
      context: context,
      title: showText,
      image: Image.asset("assets/place_visted_confirm.png",
          height: 250.0, width: 300.0),
      desc: "Leave a feedback in your own!",
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {
            place.travelDestination.markPlaceAsVisited(place),
            Navigator.pop(context)
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Review",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => _showRatingAppDialog(),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  //Dialog box for marking the place as visited
  _showWeatherDialog(
      context, String title, double latitude, double longitude) async {
    String urlName = "https://api.openweathermap.org/data/2.5/weather?lat=" +
        latitude.toString() +
        "&lon=" +
        longitude.toString() +
        "&appid=a47323fec912e74eeecd6507fb739b9d";
    var url = Uri.parse(urlName);
    var response = await http.get(url);

    var weatherDetails = [];
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      weatherDetails = jsonResponse['weather'].toSet().toList();
      //print(weatherDetails);
    }

    Alert(
      context: context,
      title: title,
      image: Image.asset("assets/place_visted_confirm.png",
          height: 250.0, width: 300.0),
      desc: weatherDetails[0]['main'].toString() +
          '\n' +
          weatherDetails[0]['description'].toString(),
    ).show();
  }

  bool isFetching = false;
  List<PlaceInformation> suggestedPlaces = [];

  var googlePlace = GooglePlace(GOOGLE_API_KEY);

  @override
  void initState() {
    super.initState();
    getNearbyPlacesData();
  }

  //get nearby places
  void getNearbyPlacesData() async {
    setState(() {
      isFetching = true;
    });

    var result = await googlePlace.search.getNearBySearch(
      Location(
          lat: place.travelDestination.latitude,
          lng: place.travelDestination.longitude),
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

          var weatherDetails = [];
          if (geometry != null) {
            location = geometry.location;
            if (location != null) {
              latitude = location.lat;
              longitude = location.lng;

              //weather details
              String urlName =
                  "https://api.openweathermap.org/data/2.5/weather?lat=" +
                      latitude.toString() +
                      "&lon=" +
                      longitude.toString() +
                      "&appid=a47323fec912e74eeecd6507fb739b9d";
              var url = Uri.parse(urlName);
              var response = await http.get(url);

              if (response.statusCode == 200) {
                var jsonResponse = jsonDecode(response.body);
                weatherDetails = jsonResponse['weather'].toSet().toList();
              }
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

          suggestedPlaces.add(placeInformation);
        }
      }
    }

    if (this.mounted) {
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(place.image, fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: 20),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          place.travelDestination.placeName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Center(
                child: Row(
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      child: Icon(
                        Icons.beenhere,
                        size: 25,
                        color: Colors.red,
                      ),
                      backgroundColor: Colors.orangeAccent,
                      onPressed: () => {
                        _showVistedMarkingDialog(
                            context, place, "Mark As Visited")
                      },
                    ),
                    SizedBox(width: 10.0),
                    FloatingActionButton(
                      heroTag: "btn2",
                      child: Icon(
                        Icons.map_sharp,
                        size: 30,
                        color: Colors.lime,
                      ),
                      backgroundColor: Colors.blueGrey,
                      onPressed: () {
                        PlaceLocation visitPlace = PlaceLocation(
                            latitude: place.travelDestination.latitude,
                            longitude: place.travelDestination.longitude,
                            placeName: place.travelDestination.placeName);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapViewScreen(visitPlace)),
                        );
                      },
                    ),
                    SizedBox(width: 10.0),
                    FloatingActionButton(
                      heroTag: "btn3",
                      child: Icon(
                        Icons.wb_sunny,
                        size: 30,
                        color: Colors.yellowAccent,
                      ),
                      backgroundColor: Colors.greenAccent,
                      onPressed: () {
                        _showWeatherDialog(
                            context,
                            place.travelDestination.placeName,
                            place.travelDestination.latitude,
                            place.travelDestination.longitude);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.blueGrey[300],
                  ),
                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${place.travelDestination.address}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\u{2B50} ${place.travelDestination.rating.toString()} \u{1F4AD} ${place.travelDestination.userRatingsTotal} Reviews",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\u{1F4C9} ${place.travelDestination.businessStatus}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\u{231B} ${(place.travelDestination.openStatus == "null") ? "No Open Details" : "Open Now"}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
              ReadMoreText(
                '${place.travelDestination.description}',
                trimLines: 2,
                colorClickableText: Colors.deepOrange,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' ...View more',
                trimExpandedText: ' Less',
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
              SizedBox(height: 5.0),
            ],
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "You May Like...",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          isFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildHorizontalList(context),
          SizedBox(height: 5.0)
        ],
      ),
    );
  }

  buildHorizontalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        // ignore: unnecessary_null_comparison
        itemCount: suggestedPlaces == null ? 0 : suggestedPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = suggestedPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  //dialog box for adding a trip
  var tripNameController = TextEditingController();
  Future<void> _addTripPlan(String placeId) async {
    //print(place.travelDestination.placeId);
    List<DropdownMenuItem<String>> menuItems = await dropdownTripItems();
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TripSelectPopUp(
          tripNameController: tripNameController,
          menuItems: menuItems,
          placeId: placeId,
        );
      },
    );
  }

  Future<List<DropdownMenuItem<String>>> dropdownTripItems() async {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(child: Text("Choose"), value: "null"));
    await FirebaseFirestore.instance
        .collection("trips")
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length != 0) {
        querySnapshot.docs.forEach((doc) async {
          menuItems.add(DropdownMenuItem(
              child: Text(doc["tripName"]), value: doc.reference.id));
        });
      } else {
        menuItems.add(DropdownMenuItem(child: Text("No Trips"), value: "null"));
      }
    });
    return menuItems;
  }
}
