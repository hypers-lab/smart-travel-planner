import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/places/MapViewerScreen.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'dart:convert' as convert;
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
      ratingColor: Colors.amber,
      title: 'Rate Travel Place',
      message: 'Rating the place and tell others what you think.'
          ' Add a comment if you want.',
      submitButton: 'Submit',
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
  _showVistedMarkingDialog(context, String showText) {
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
            place.travelDestination.markPlaceAsVisited(),
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

  bool isFetching = false;
  List<TravelDestination> suggestedPlaces = [];

  @override
  void initState() {
    super.initState();
    //getGroupsData();
  }

  //retrive places similar to selected place from the model
  // Future<void> getGroupsData() async {
  //   setState(() {
  //     isFetching = true;
  //   });

  //   String urlName =
  //       'https://sep-recommender.herokuapp.com/recommend?hotel_id=' +
  //           place.placeId.toString();
  //   var url = Uri.parse(urlName);
  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //     var suggestPlacesIds =
  //         jsonResponse['recommended_hotels'].toSet().toList();

  //     for (var i = 0; i < 10; i++) {
  //       FirebaseFirestore.instance
  //           .collection("hotels")
  //           .where("hotelId", isEqualTo: suggestPlacesIds[i])
  //           .limit(1)
  //           .get()
  //           .then((querySnapshot) {
  //         querySnapshot.docs.forEach((result) {
  //           TravelDestination travelDestination = TravelDestination(
  //               city: result.data()["city"],
  //               placeId: result.data()["hotelId"],
  //               placeName: result.data()["hotelName"],
  //               mainPhotoUrl: result.data()["mainPhotoUrl"],
  //               reviewScore: result.data()["reviewScore"].toString(),
  //               reviewScoreWord: result.data()["reviewScoreWord"],
  //               reviewText: result.data()["reviewText"],
  //               description: result.data()["description"],
  //               coordinates: result.data()["coordinates"],
  //               checkin: result.data()["checkin"],
  //               checkout: result.data()["checkout"],
  //               address: result.data()["address"],
  //               url: result.data()["url"],
  //               introduction: result.data()["introduction"]);

  //           suggestedPlaces.add(travelDestination);
  //           setState(() {
  //             isFetching = false;
  //           });
  //         });
  //       });
  //     }
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box,
              color: Colors.blue,
              size: 24.0,
            ),
            onPressed: () {
              _addTripPlan();
            },
          ),
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications_none,
              color: Colors.amber,
              size: 24.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(place.image, fit: BoxFit.fill),
              ),
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
                  Expanded(
                    child: Container(
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
                  ),
                  FloatingActionButton(
                    heroTag: "btn1",
                    child: Icon(
                      Icons.beenhere,
                      size: 25,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.orangeAccent,
                    onPressed: () =>
                        {_showVistedMarkingDialog(context, "Mark As Visited")},
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
                  )
                ],
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
              SizedBox(height: 10.0),
            ],
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Suggested Travel Places",
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
              : SizedBox(
                  height: 100.0,
                ), //buildHorizontalList(context),
          SizedBox(height: 10.0)
        ],
      ),
    );
  }

  // buildHorizontalList(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 10.0, left: 20.0),
  //     height: 250.0,
  //     width: MediaQuery.of(context).size.width,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       primary: false,
  //       // ignore: unnecessary_null_comparison
  //       itemCount: suggestedPlaces == null ? 0 : suggestedPlaces.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         PlaceInformation place = suggestedPlaces[index];
  //         return HorizontalPlaceItem(place);
  //       },
  //     ),
  //   );
  // }

  //dialog box for adding a trip
  var tripNameController = TextEditingController();
  Future<void> _addTripPlan() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TripSelectPopUp(tripNameController: tripNameController);
      },
    );
  }
}
