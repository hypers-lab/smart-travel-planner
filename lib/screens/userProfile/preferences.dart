import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_travel_planner/appBrain/Preferences.dart';
import 'package:smart_travel_planner/screens/userProfile/edit_preferences.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';

class PreferenceOfUser extends StatefulWidget {
  const PreferenceOfUser({Key? key}) : super(key: key);

  @override
  _PreferenceOfUserState createState() => _PreferenceOfUserState();
}

class _PreferenceOfUserState extends State<PreferenceOfUser> {
  bool isFetching = false;
  void initState() {
    super.initState();
    getPreferencesOfUser();
  }

  final String uid = UserPreferences.getCurrentUserId();

  //list for the areas and place types
  List preferredAreas = [
    'Ampara',
    'Anuradhapura',
    'Badulla',
    'Batticaloa',
    'Colombo',
    'Galle',
    'Gampaha',
    'Hambantota',
    'Jaffna',
    'Kalutara',
    'Kandy',
    'Kegalle',
    'Kilinochchi',
    'Kurunegala',
    'Mannar',
    'Matale',
    'Matara',
    'Moneragala',
    'Mullaitivu',
    'Nuwara Eliya',
    'Polonnaruwa',
    'Puttalam',
    'Ratnapura',
    'Trincomalee',
    'Vavuniya'
  ];
  List preferredTypes = [
    'Cafe',
    'Church',
    'Clothing store',
    'Gym',
    'Hindu temple',
    'Home goods store',
    'Library',
    'Mosque',
    'Movie theater',
    'Museum',
    'Night club',
    'Park',
    'Shopping mall',
    'Super market',
    'Zoo',
    'Spa',
    'Restaurant',
    'Pet store',
    'Meal delivery',
    'Meal takeaway',
    'Lodge'
  ];

  //recieve user preferences from database
  List userPreferedArea = [];
  List userPreferedType = [];

  List area = [];
  List place = [];

  String parea = '';
  String pplace = '';

  //get user details as instance from server
  Future getPreferencesOfUser() async {
    setState(() {
      isFetching = true;
    });

    await FirebaseFirestore.instance
        .collection('userPreferences')
        .doc((FirebaseAuth.instance.currentUser)?.uid)
        .get()
        .then((value) {
      UserPreferences userPreference = UserPreferences(
        types: value.get('preferredTypes'),
        areas: value.get('preferredAreas'),
      );

      userPreferedArea = userPreference.areas;
      userPreferedType = userPreference.types;

      for (int val in userPreferedArea) {
        area.add(preferredAreas[val]);
        parea += preferredAreas[val] + ', ';
      }
      print(parea);
      area.toString();

      for (int val in userPreferedType) {
        place.add(preferredTypes[val]);
        pplace += preferredTypes[val] + ', ';
      }
    });

    setState(() {
      isFetching = false;
    });
  }

  // //instance for firebase and current user
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // var firebaseUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        title: Text('Your preferences'),
        centerTitle: true,
      ),
      body: isFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/travel.jpg'),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),

                  //show the preferred place and area in the screen
                  infoContent(
                      information: parea, title: 'Your preferred areas'),
                  SizedBox(height: 30),
                  infoContent(
                      information: pplace, title: 'Your preferred place types'),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Preference()));
                        },
                        child: Text(
                          'Edit your preferences',
                          style: TextStyle(),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          primary: Colors.teal[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          onPrimary: Colors.white,
                          shadowColor: Colors.blueGrey,
                          elevation: 10,
                        ),
                      )),
                ],
              ),
            )),
    );
  }
}

//reused widget inside the body content
Widget infoContent({
  required String information,
  required String title,
}) =>
    Card(
      elevation: 15,
      color: Colors.green[100],
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        title: Center(
          child: Text(
            title,
            style: GoogleFonts.dmSerifDisplay(
                fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: 1),
          ),
        ),
        subtitle: Center(
          child: Text(
            information,
            style: GoogleFonts.shadowsIntoLight(
                fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 3),
          ),
        ),
      ),
    );
