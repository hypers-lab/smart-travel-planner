import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_travel_planner/appBrain/user.dart';
import 'edit_personal_info.dart';
import 'profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool isFetching = false;
  void initState() {
    super.initState();
    getUserDetails();
  }

  final String uid = UserDetails.getCurrentUserId();

  // to assign values get from firestore
  var username;
  var userage;
  var userphonenumber;
  var usergender;

  var ageCheck;
  //get user details as instance from server
  Future getUserDetails() async {
    setState(() {
      isFetching = true;
    });

    await FirebaseFirestore.instance
        .collection('user_personal_information')
        .doc(uid)
        .get()
        .then((value) {
      ageCheck = value.get('age');

      if (ageCheck == 0) {
        UserDetails user = UserDetails(
            name: value.get('name'),
            age: '',
            gender: value.get('gender'),
            phonenumber: value.get('phone_number'));

        username = user.name;
        userage = user.age;
        userphonenumber = user.phonenumber;
        usergender = user.gender;
      } else {
        UserDetails user = UserDetails(
            name: value.get('name'),
            age: value.get('age').toString(),
            gender: value.get('gender'),
            phonenumber: value.get('phone_number'));

        username = user.name;
        userage = user.age;
        userphonenumber = user.phonenumber;
        usergender = user.gender;
      }
    });

    setState(() {
      isFetching = false;
    });
  }

  //instance for firebase and current user
  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        leading: BackButton(
          key: Key("backButton"),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        title: Text('Account Personal Info'),
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
                    height: 40,
                  ),
                  infoContent(
                      information: '${firebaseUser!.email}', title: 'Email'),
                  infoContent(information: '$username', title: 'Name'),
                  infoContent(information: '$userage', title: 'Age'),
                  infoContent(
                      information: '$userphonenumber', title: 'Phone Number'),
                  infoContent(information: '$usergender', title: 'Gender'),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        child: Text(
                          'Edit Personal Info',
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

  //the repeating widget content of body
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
}
