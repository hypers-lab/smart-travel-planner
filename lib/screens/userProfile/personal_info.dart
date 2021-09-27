import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_personal_info.dart';
import 'profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {

  var age;
  var name;
  var phonenumber;
  var gender;

  void initState() {
    super.initState();

    getUserDetails();
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ProfilePage()));},
        ),
        title: Text('Account Personal Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/travel.jpg'),
                  fit: BoxFit.fill)),
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                ),
                infoContent(information: '${firebaseUser!.email}', title: 'Email'),
                infoContent(information: '$name', title: 'Name'),
                infoContent(information: '$age', title: 'Age'),
                infoContent(information: '$phonenumber', title: 'Phone Number'),
                infoContent(information: '$gender', title: 'Gender'),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => EditProfilePage()));
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
                    )
                  ),
              ],
            ),
          )
      ),
    );
  }

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
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: 1
              ), 
            ),
          ),
          subtitle: Center(
            child: Text(
              information,
              style: GoogleFonts.shadowsIntoLight(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 3
              ),
            ),
          ),
        ),
      );

  Future getUserDetails() async{
    await FirebaseFirestore.instance
      .collection('user_personal_information')
      .doc(( FirebaseAuth.instance.currentUser!).uid)
      .get()
      .then((value) {
        setState(() {
          name = value.get('name').toString();
          phonenumber = value.get('phone number').toString();
          age = value.get('age').toString();
          gender = value.get('gender');
        });
      });
      return 'Fetching error';
  }
}
