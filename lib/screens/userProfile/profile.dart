import 'package:flutter/material.dart';
import 'package:smart_travel_planner/widgets/profile_menu_item.dart';
import 'change_password.dart';
import 'history.dart';
import 'personal_info.dart';
import 'preferences.dart';
import '../MainScreen.dart';
import '../user/LoginScreen.dart';
import '../../widgets/profile_pic.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
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
                    MaterialPageRoute(builder: (context) => PersonalInfoScreen()));
                  }),
              ProfileMenu(
                  text: 'Preferences',
                  icon: Icon(Icons.favorite_outline_rounded),
                  press: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Preference()));
                  }),
              ProfileMenu(
                  text: 'History',
                  icon: Icon(Icons.history),
                  press: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => History()));
                  }),
              ProfileMenu(
                  text: 'Change password',
                  icon: Icon(Icons.security_outlined),
                  press: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ChangePassword()));
                  }),
              ProfileMenu(
                  text: 'Signout',
                  icon: Icon(Icons.logout),
                  press: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
