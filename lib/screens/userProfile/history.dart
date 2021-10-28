import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String uid = VisitedHistory.getCurrentUserId();
  List placesId = [];
  List<VisitedHistory> places = [];
  //to assign values of instance objects under listview.builder widget
  String name = '';
  String score = '';
  String city = '';
  String address = '';
  
  void initState() {
    super.initState();
    getVisitedPlaces();
  }

  //for search bar
  final TextEditingController _searchControl = new TextEditingController();
  List<VisitedHistory> _searchResult = [];
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    places.forEach((place) {
      if (place.placeName.contains(text)) _searchResult.add(place);
    });

    setState(() {});
  }

  //get all the place details of current user visited
  getVisitedPlaces() {
    setState(() {
      isFetching = true;
    });
    FirebaseFirestore.instance
        .collection("visitedPlaces")
        .where('userId', isEqualTo: uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        VisitedHistory history = VisitedHistory(
          placeName: result['placeName'],
          reviewScore: result['reviewScore'].toString(),
          city: result['address'],
          address: result['description'],
        );

        places.add(history);
      });
      setState(() {
        isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: Text('Your Travelling History'),
          centerTitle: true,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    color: Colors.blueGrey[50],
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: _searchControl,
                        decoration: new InputDecoration(
                            hintText: 'Search by a place..',
                            border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          _searchControl.clear();
                          onSearchTextChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
                          child: _searchResult.length != 0 ||
                                  _searchControl.text.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _searchResult.length,
                                  itemBuilder: (BuildContext context, index) {
                                    name = _searchResult[index].placeName;
                                    city = _searchResult[index].city;
                                    address = _searchResult[index].address;
                                    score = _searchResult[index].reviewScore;

                                    return infoHistoryContent(
                                        hotelName: name,
                                        city: city,
                                        address: address,
                                        reviewScore: score,
                                        tap: () {});
                                  })
                              : new ListView.builder(
                                  itemCount: places.length,
                                  itemBuilder: (BuildContext context, index) {
                                    name = places[index].placeName;
                                    city = places[index].city;
                                    address = places[index].address;
                                    score = places[index].reviewScore;

                                    return infoHistoryContent(
                                        hotelName: name,
                                        city: city,
                                        address: address,
                                        reviewScore: score,
                                        tap: () {});
                                  }),
                        )
            ],
          ),
        ));
  }
}
