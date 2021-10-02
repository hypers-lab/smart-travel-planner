import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/widgets/vertical_place_item.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchControl = new TextEditingController();

  //store search results
  List<TravelDestination> queryResultSet = [];
  // store suitable search results temporaly
  List<TravelDestination> tempSearchStore = [];
  //retrive data to be serached
  List<TravelDestination> places = [];

  @override
  void initState() {
    super.initState();
    getPlaceData();
  }

  //get the data to iterate in search
  Future<void> getPlaceData() async {
    await FirebaseFirestore.instance
        .collection("hotels")
        .limit(20)
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
    });
  }

  //search on the keyword changes on search bar
  initiateSearch(value) {
    print(value);
    print(queryResultSet);
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length > 0) {
      for (TravelDestination place in places) {
        if (place.city == value) {
          queryResultSet.add(place);
        }
      }
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element.city.startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          onChanged: (val) {
            initiateSearch(val);
          },
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.blueGrey[300],
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "E.g: Peradeniya, Kandy",
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
          ),
          maxLines: 1,
          controller: _searchControl,
        ),
      ),
      (tempSearchStore.isNotEmpty)
          ? buildVerticalList(context)
          : SizedBox(height: 1.0),
    ]);
  }

  //vertical list places of search results
  buildVerticalList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tempSearchStore.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = tempSearchStore[index];
          return VerticalPlaceItem(place);
        },
      ),
    );
  }
}
