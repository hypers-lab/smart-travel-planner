import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/HomeViewScreen.dart';
import 'package:smart_travel_planner/screens/userProfile/preferences.dart';
import 'package:smart_travel_planner/widgets/profile_menu_item.dart';
import 'change_password.dart';
import 'history.dart';
import 'personal_info.dart';
import '../user/LoginScreen.dart';
import '../../widgets/profile_pic.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  // Back Button Android Behaviour
  Future<bool> _onBackPressed() async {
    final shouldPop = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Are you sure you want to leave this page?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: <Widget>[
                SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage(), // Destination
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "YES",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "NO",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ));
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/bg1.jpg'),
              fit: BoxFit.cover,
            )),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                ProfilePic(),
                SizedBox(
                  height: 10,
                ),
                ProfileMenu(
                    text: 'Peronal Information',
                    icon: Icon(Icons.person_outline_outlined),
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonalInfoScreen()));
                    }
                ),
                ProfileMenu(
                    text: 'Preferences',
                    icon: Icon(Icons.favorite_outline_rounded),
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreferenceOfUser()));
                    }
                ),
                ProfileMenu(
                    text: 'History',
                    icon: Icon(Icons.history),
                    press: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => History()));
                    }
                ),
                ProfileMenu(
                    text: 'Change password',
                    icon: Icon(Icons.security_outlined),
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                    }
                ),
                ProfileMenu(
                    text: 'Signout',
                    icon: Icon(Icons.logout),
                    press: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
