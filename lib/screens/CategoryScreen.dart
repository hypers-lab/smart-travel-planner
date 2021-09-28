import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/widgets/category_button_widget.dart';
import '../widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isFetching = false;
  List<TravelDestination> places = [];
  late ScrollController _hotelScrollController;
  int loadMoreMsgs = 25; // at first it will load only 25
  int a = 50;

  //default category name
  String categoryName = "Hotels";

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

  //function to retrive data based on category
  _getCategoryBasedData(String category) {
    setState(() {
      categoryName = category;
      //get data from firebase and create list of places
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
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CategoryButton(
                          buttonFunc: () => {_getCategoryBasedData("Beaches")},
                          buttonIcon: Icons.beach_access,
                          buttonColor: Colors.amber.shade300,
                          iconColor: Colors.lightBlue.shade300),
                      CategoryButton(
                          buttonFunc: () =>
                              {_getCategoryBasedData("Cofeeshops")},
                          buttonIcon: Icons.fastfood,
                          buttonColor: Colors.redAccent,
                          iconColor: Colors.yellow),
                      CategoryButton(
                          buttonFunc: () => {_getCategoryBasedData("Nature")},
                          buttonIcon: Icons.landscape,
                          buttonColor: Colors.lightGreen,
                          iconColor: Colors.brown.shade700),
                      CategoryButton(
                          buttonFunc: () => {_getCategoryBasedData("Hotels")},
                          buttonIcon: Icons.hotel,
                          buttonColor: Colors.blueGrey.shade900,
                          iconColor: Colors.yellow.shade900),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Text(
                    "Travel Places: $categoryName",
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
            );
          }),
    );
  }

  //vertical list view based on the selected category
  buildVerticalList(BuildContext context) {
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
