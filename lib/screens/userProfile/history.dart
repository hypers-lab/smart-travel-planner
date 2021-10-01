import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/visited_history.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';
import 'package:smart_travel_planner/util/places.dart';
import 'package:smart_travel_planner/widgets/history_items.dart';


class History extends StatefulWidget {
  
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  
  final TextEditingController _searchControl = new TextEditingController();

  List placesId =[];
  bool isFetching = false;
  List<VisitedHistory> places = [];
  
  //instance for firebase and current user
  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    getVisitedHotelsId();
    
  }

  getVisitedHotelsId() {

    setState(() {
      isFetching = true;
    });

    FirebaseFirestore.instance
      .collection("visitedInformation")
      .where('userId',isEqualTo: firebaseUser!.uid)
      .get()
      .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          placesId.add(result["placeId"]);
          //print(placesId);
        });

    getVisitedHotelsDetails();

    setState(() {
      isFetching = false;
    });
    });
  }

   getVisitedHotelsDetails() {
     //print(55555556+666666);
    // setState(() {
    //   isFetching = true;
    // });
    FirebaseFirestore.instance
      .collection("hotels")
      .where('hotelId',whereIn: placesId)
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
        //   print(places);
        //  print(result.data());
        });
        print(places[0].introduction,);
        print(places[1].introduction,);
        print(places[2].introduction,);
        print(places[3].introduction,);

      // setState(() {
      //   isFetching = false;
      // });
    });return places;
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body:SingleChildScrollView(
            child: Column(
              children: [
                searchBar(),
                
                // ListView.builder(
                //   itemCount: 2,
                //   itemBuilder: (BuildContext context, int index) {
                //     return infoHistoryContent(
                //       hotelName: 'hotelName', 
                //       city: 'city', 
                //       address: 'address', 
                //       introduction: 'introduction', 
                //       reviewScore: 'reviewScore', 
                //       tap: (){});
                //   })
              ],
            ),
            )
    );

    
    
  }

  Widget searchBar(){
    return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/pic.jpg'),
                  fit: BoxFit.cover,),
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child:Stack (children: <Widget>[
              TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
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
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),

                  hintText: "Search by a place..",

                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),

                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),

                ),
                maxLines: 1,

                controller: _searchControl,
              ),
            ])
          ),);
  }
}
