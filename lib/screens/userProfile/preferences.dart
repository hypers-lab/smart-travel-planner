import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:smart_travel_planner/appBrain/Preferences.dart';
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

  void initState() {
    super.initState();
    //getData();
  }

  //to send the selected prefered items to firestore
  List? _myActivitiesTypes;
  List? _myActivitiesAreas;

  //The drop down list
  List preferredAreas = ['Jaffna', 'Kandy'];
  List preferredTypes = ['Lodging'];

  // CollectionReference _collectionTypes =
  //     FirebaseFirestore.instance.collection('preferredTypes');
  // CollectionReference _collectionAreas =
  //     FirebaseFirestore.instance.collection('preferredAreas');

  //get the dropdown menus from firestore
  // Future<void> getData() async {
  //   setState(() {
  //     isFetching = true;
  //   });
  //   QuerySnapshot querySnapshotAreas = await _collectionAreas.get();
  //   final areas = querySnapshotAreas.docs.map((doc) => doc.get('area_name'));
  //   preferredAreas = areas.toList();
  //   preferredAreas.sort();
  //   print(preferredAreas);

  //   QuerySnapshot querySnapshotTypes = await _collectionTypes.get();
  //   final types = querySnapshotTypes.docs.map((doc) => doc.get('PlaceName'));
  //   preferredTypes = types.toList();
  //   preferredTypes.sort();

  //   getPreferencesOfUser();

  //   setState(() {
  //     isFetching = false;
  //   });
  // }

  //get current user's preferences
  Future getPreferencesOfUser() async {
    setState(() {
      isFetching = true;
    });
    await FirebaseFirestore.instance
        .collection('userPreferences')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      UserPreferences userPreference = UserPreferences(
        types: value.get('preferredTypes'),
        areas: value.get('preferredAreas'),
      );

      print(userPreference.types);
    });

    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add You Preferences....'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
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
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: preferenceOption(
                              items: preferredTypes,
                              onSelectedItems: _myActivitiesTypes),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: preferenceOption(
                              items: preferredAreas,
                              onSelectedItems: _myActivitiesAreas),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width) / 2 + 30,
                          child: Row(
                            children: [
                              button(
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
                              button(
                                  text: 'Save',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Your preferences are saved'),
                                    ));
                                    _sendToServer();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
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

  Widget preferenceOption({
    required List items,
    List? onSelectedItems,
  }) =>
      GFMultiSelect(
        items: items,
        onSelect: (value) {
          setState(() {
            onSelectedItems = value;
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
        ),
        dropdownTitleTileTextStyle:
            const TextStyle(fontSize: 14, color: Colors.black54),
        padding: const EdgeInsets.fromLTRB(18, 2, 20, 2),
        margin: const EdgeInsets.all(6),
        activeBgColor: Colors.green.shade100,
        inactiveBorderColor: Colors.green.shade100,
      );

  // Send the preference values to userPreferences collection
  _sendToServer() async {
    _saveForm();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('userPreferences')
        .doc('xjtZPHcYBVWbKGcTkpALlfGkWoM2')
        .update({
      'preferredTypes': _myActivitiesTypes,
      'preferredAreas': _myActivitiesAreas,
    });
  }

  //save the values
  _saveForm() {
    _formkey.currentState!.save();
  }
}
