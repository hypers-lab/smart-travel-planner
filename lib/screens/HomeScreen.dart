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
    setState(() {
      isFetching = true;
    });

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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView(
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
                streamSnapshot.connectionState == ConnectionState.none
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ListView.builder(
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          // ignore: unnecessary_null_comparison
                          itemCount: loadMoreMsgs,
                          controller: _hotelScrollController,
                          itemBuilder: (BuildContext context, int index) {
                            TravelDestination place = TravelDestination(
                                city: streamSnapshot.data!.docs[index]['city'],
                                placeId: streamSnapshot.data!.docs[index]
                                    ['hotelId'],
                                placeName: streamSnapshot.data!.docs[index]
                                    ['hotelName'],
                                mainPhotoUrl: streamSnapshot.data!.docs[index]
                                    ['mainPhotoUrl'],
                                reviewScore: streamSnapshot.data!.docs[index]['reviewScore']
                                    .toString(),
                                reviewScoreWord: streamSnapshot.data!.docs[index]
                                    ['reviewScoreWord'],
                                reviewText: streamSnapshot.data!.docs[index]
                                    ['reviewText'],
                                description: streamSnapshot.data!.docs[index]
                                    ['description'],
                                coordinates: streamSnapshot.data!.docs[index]
                                    ['coordinates'],
                                checkout: streamSnapshot.data!.docs[index]
                                    ['checkout'],
                                checkin: streamSnapshot.data!.docs[index]
                                    ['checkin'],
                                address: streamSnapshot.data!.docs[index]
                                    ['address'],
                                url: streamSnapshot.data!.docs[index]['url'],
                                introduction: streamSnapshot.data!.docs[index]
                                    ['introduction']);
                            return VerticalPlaceItem(place);
                          },
                        ),
                      ),
                //buildHorizontalList(context),
                //buildVerticalList(),
              ],
            );
          }),
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
}
