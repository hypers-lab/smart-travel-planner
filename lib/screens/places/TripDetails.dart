import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'package:smart_travel_planner/widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/widgets/vertical_trip_place_item.dart';
import '../../widgets/horizontal_place_item.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

import '../MainScreen.dart';

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
  List<TravelDestination> places = [];
  late ScrollController _hotelScrollController;
  int loadMoreMsgs = 25; // at first it will load only 25
  int a = 50;

  @override
  void initState() {
    super.initState();
    getGroupsData();
    _hotelScrollController = ScrollController()
      ..addListener(() {
        if (_hotelScrollController.position.atEdge) {
          if (_hotelScrollController.position.pixels != 0)
            setState(() {
              loadMoreMsgs = loadMoreMsgs + a;
            });
        }
      });
  }

  getGroupsData() {
    print(trip.places);
    trip.places.forEach((placeId) {
      FirebaseFirestore.instance
          .collection("hotels")
          .where('hotelId', isEqualTo: placeId)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
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
            introduction: doc["introduction"],
          );
          places.add(travelDestination);
        });
        setState(() {
          isFetching = false;
        });
      });
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
              : buildVerticalList()
        ],
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
          TravelDestination place = places[index];
          return VerticalTripPlaceItem(place);
        },
      ),
    );
  }
}
