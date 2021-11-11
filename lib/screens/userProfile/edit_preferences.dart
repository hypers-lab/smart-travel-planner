import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_travel_planner/screens/userProfile/preferences.dart';
import 'package:smart_travel_planner/widgets/button.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  bool isFetching = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //to send the selected prefered items to firestore
  List _myActivitiesTypes = [];
  List _myActivitiesAreas = [];

  //The drop down items' list for preferred areas
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

  //The drop down items' list for preferred place types
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('Add You Preferences....'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => PreferenceOfUser())
            );
          },
        ),
      ),
      body: isFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/edit2.jpg'),
                        fit: BoxFit.fill)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Add your preferences \nto get place suggestions \nbased on that........',
                            style: GoogleFonts.shadowsIntoLight(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 2,
                                color: Colors.green[900]),
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: preferenceItemAreas()),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: preferenceItemTypes(),
                        ),
                        SizedBox(
                          height: 80,
                        ),

                        //buttons for save and cancel
                        Container(
                          width: (MediaQuery.of(context).size.width) / 2 + 30,
                          child: Row(
                            children: [

                              //cancel button
                              button(
                                  key:Key("cancelButtonPreference"),
                                  text: 'Cancel',
                                  color: Colors.red.shade900,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  }),
                              SizedBox(
                                width: 10,
                              ),

                              //save button
                              button(
                                key: Key("saveButtonPreference"),
                                text: 'Save',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      SnackBar(
                                        key: Key("snackbarPreference"),
                                        content:
                                          Text('Your preferences are saved'),
                                      )
                                    );
                                  //call _sendToServer function to send the preferences to database
                                  _sendToServer();
                                    
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>PreferenceOfUser()
                                    )
                                  );
                                },
                                color: Colors.teal.shade900),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
  //widget dropdown for selecting preferred areas
  GFMultiSelect preferenceItemAreas() {
    return GFMultiSelect(
      key: Key("area"),
      items: preferredAreas,
      onSelect: (value) {
        print('Selected $value');
        setState(() {
          _myActivitiesAreas = value;
        });
      },
      dropdownTitleTileText: 'Select your prefered areas',
      dropdownTitleTileColor: Colors.green[100],
      dropdownTitleTileMargin: EdgeInsets.all(0),
      dropdownTitleTilePadding: EdgeInsets.all(10),
      dropdownUnderlineBorder:
          const BorderSide(color: Colors.transparent, width: 2),
      dropdownTitleTileBorder:
          Border.all(color: Colors.grey.shade700, width: 1),
      dropdownTitleTileBorderRadius: BorderRadius.circular(10),
      expandedIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black54,
      ),
      collapsedIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.black54,
      ),
      submitButton: Text(
        'OK',
        key: Key('submitButton'),
      ),
      cancelButton: Text(
        'CANCEL',
         key: Key('cancelButton1'),),
      dropdownTitleTileTextStyle:
          const TextStyle(fontSize: 14, color: Colors.black54),
      padding: const EdgeInsets.fromLTRB(18, 2, 20, 2),
      margin: const EdgeInsets.all(6),
      activeBgColor: Colors.green.shade100,
      inactiveBorderColor: Colors.green.shade100,
    );
  }

  //widget dropdown for selecting preferred place types
  GFMultiSelect preferenceItemTypes() {
    return GFMultiSelect(
      key: Key("place"),
      items: preferredTypes,
      onSelect: (value) {
        print('Selected $value');
        setState(() {
          _myActivitiesTypes = value;
        });
      },
      dropdownTitleTileText: 'Select your prefered place types',
      dropdownTitleTileColor: Colors.green[100],
      dropdownTitleTileMargin: EdgeInsets.all(0),
      dropdownTitleTilePadding: EdgeInsets.all(10),
      dropdownUnderlineBorder:
          const BorderSide(color: Colors.transparent, width: 2),
      dropdownTitleTileBorder:
          Border.all(color: Colors.grey.shade700, width: 1),
      dropdownTitleTileBorderRadius: BorderRadius.circular(10),
      expandedIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black54,
      ),
      collapsedIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.black54,
      ),
      submitButton: Text(
        'OK',
      ),
      cancelButton: Text(
        'CANCEL',
         key: Key('cancelButton2'),),
      dropdownTitleTileTextStyle:
          const TextStyle(fontSize: 14, color: Colors.black54),
      padding: const EdgeInsets.fromLTRB(18, 2, 20, 2),
      margin: const EdgeInsets.all(6),
      activeBgColor: Colors.green.shade100,
      inactiveBorderColor: Colors.green.shade100,
    );
  }

  // Send the preference values to userPreferences collection
  _sendToServer() async {
    _saveForm();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('userPreferences')
        .doc(firebaseUser?.uid)
        .update({
      'preferredTypes': _myActivitiesTypes,
      'preferredAreas': _myActivitiesAreas,
    });
  }

  //save the values
  _saveForm() {
    _formkey.currentState?.save();
  }
}
