import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/visited_history.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';
import 'package:smart_travel_planner/widgets/history_items.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isFetching = false;

  //instance for firebase and current user
  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  List placesId = [];
  List<VisitedHistory> places = [];

  //for search bar
  List hotels = [];
  final TextEditingController _searchControl = new TextEditingController();
  String _searchText = "";

  // void initState() {
  //   super.initState();
  //   print("object");
  //   _searchControl.addListener(() {
  //     if (_searchControl.text.isEmpty) {
  //       setState(() {
  //         _searchText = "";
  //         updateFilter(_searchText);
  //       });
  //     } else {
  //       setState(() {
  //         _searchText = _searchControl.text;
  //         updateFilter(_searchText);
  //       });
  //     }
  //   });
  // }

  //to assign values of instance objects under builder widget
  String name = '';
  String intro = '';
  String score = '';
  String city = '';
  String address = '';

  void initState() {
    super.initState();
    getVisitedHotelsId();
  }

  //get all the hotels id of current user visited
  getVisitedHotelsId() {
    setState(() {
      isFetching = true;
    });
    FirebaseFirestore.instance
        .collection("visitedInformation")
        .where('userId', isEqualTo: firebaseUser!.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        placesId.add(result.data()['placeId']);
      });

      getVisitedHotelsDetails();

      setState(() {
        isFetching = false;
      });
    });
  }

  //get visited hotels information
  getVisitedHotelsDetails() {
    if (placesId.isNotEmpty) {
      setState(() {
        isFetching = true;
      });
      FirebaseFirestore.instance
          .collection("hotels")
          .where('hotelId', whereIn: placesId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          VisitedHistory history = VisitedHistory(
              hotelName: result['hotelName'],
              reviewScore: result['reviewScore'].toString(),
              city: result['city'],
              address: result['address'],
              introduction: result['introduction']);

          places.add(history);
          hotels.add(history.hotelName);
          print(hotels);
        });
        setState(() {
          isFetching = false;
        });
      });
      return places;
    } else
      return 'There is no history';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Travelling History'),
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              searchBar(),
              isFetching
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : places.isEmpty
                      ? Container(
                          height: 500,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 100, 12, 20),
                            child: Text(
                              'No travelling history.....',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                      : Container(
                          height: 500,
                          child: ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (BuildContext context, index) {
                                name = places[index].hotelName;
                                city = places[index].city;
                                address = places[index].address;
                                intro = places[index].introduction;
                                score = places[index].reviewScore;

                                return infoHistoryContent(
                                    hotelName: name,
                                    city: city,
                                    address: address,
                                    introduction: intro,
                                    reviewScore: score,
                                    tap: () {});
                              }),
                        )
            ],
          ),
        ));
  }

  Widget searchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Stack(children: <Widget>[
            TextField(
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Search by a place..",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
              controller: _searchControl,
            ),
          ])),
    );
  }
}
