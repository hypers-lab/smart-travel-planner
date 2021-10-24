import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/screens/itenerary/SearchScreen.dart';
import 'package:smart_travel_planner/widgets/horizontal_trip_item.dart';
import 'package:smart_travel_planner/widgets/verticle_trip_item.dart';

class IteneraryScreen extends StatefulWidget {
  const IteneraryScreen({Key? key}) : super(key: key);

  @override
  _IteneraryScreenState createState() => _IteneraryScreenState();
}

class _IteneraryScreenState extends State<IteneraryScreen> {
  bool isFetching = true;
  bool isDataExist = true;
  //final List<Trip> _trips = Trip.getTripDetailsDummy();
  List<Trip> trips = [];
  late ScrollController _tripScrollController;
  int loadMoreMsgs = 25; // at first it will load only 25
  int a = 50;

  @override
  void initState() {
    super.initState();
    getGroupsData();
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

  getGroupsData() async {
    setState(() {
      isDataExist = true;
    });
    await FirebaseFirestore.instance
        .collection("trips")
        .orderBy('date')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((doc) {
          Trip trip = Trip(
              tripName: doc["tripName"],
              places: doc["places"],
              date: doc["date"].toDate(),
              image: doc["image"],
              status: doc["status"],
              userId: doc["userId"]);
          trips.add(trip);
          setState(() {
            isFetching = false;
          });
        });
      } else {
        setState(() {
          isDataExist = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          isFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildHorizontalList(context),
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
              : isDataExist
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
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: trips.length,
        itemBuilder: (BuildContext context, int index) {
          Trip trip = trips.reversed.toList()[index];
          return HorizontalTripItem(trip);
        },
      ),
    );
  }

  buildVerticalList() {
    final ids = Set();
    trips.retainWhere((x) => ids.add(x.tripName));
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: trips.length,
        itemBuilder: (BuildContext context, int index) {
          Trip trip = trips.reversed.toList()[index];
          return VerticalTripItem(trip);
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

                await FirebaseFirestore.instance
                    .collection("trips")
                    .where("tripName", isEqualTo: tripName)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.docs.length == 0) {
                    //adding to firebase
                    CollectionReference trips =
                        FirebaseFirestore.instance.collection('trips');
                    trips.add({
                      'tripName': tripName,
                      'date': now,
                      'status': 0,
                      'userId': userdId,
                      'image':
                          'https://cf.bstatic.com/xdata/images/hotel/square600/76655679.jpg?k=119a180340fa23c00d859e95fa02046eb17980bccb43295fe6550a5ea968daad&o=',
                      'places': []
                    });
                    getGroupsData();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Trip Name already exists."),
                      ),
                    );
                  }
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
