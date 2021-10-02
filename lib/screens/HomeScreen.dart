import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/horizontal_place_item.dart';
import '../widgets/search_bar.dart';
import '../widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFetching = true;
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
    FirebaseFirestore.instance
        .collection("hotels")
        .limit(10)
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
            padding: EdgeInsets.all(20.0),
            child: SearchBar(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Suggested Travel Places",
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
              : buildHorizontalList(context),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Hotels",
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
              : buildVerticalList(),
        ],
      ),
    );
  }

  buildHorizontalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = places.reversed.toList()[index];
          return HorizontalPlaceItem(place);
        },
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
          return VerticalPlaceItem(place);
        },
      ),
    );
  }

  //search results
  buildVerticalSearchResultList() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = places[index];
          return VerticalPlaceItem(place);
        },
      ),
    );
  }
}
