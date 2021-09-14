import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/User_Profile/change_password.dart';
import 'package:smart_travel_planner/screens/User_Profile/history.dart';
import 'package:smart_travel_planner/screens/User_Profile/personal_info.dart';
import 'package:smart_travel_planner/screens/User_Profile/preferences.dart';
import 'package:smart_travel_planner/screens/main_screen.dart';
import 'package:smart_travel_planner/screens/user/login.dart';
import 'package:smart_travel_planner/widgets/profile_menu_item.dart';
import 'package:smart_travel_planner/widgets/profile_pic.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile';

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
          onPressed: (){
            Navigator.of(context).pop(true);
            Navigator.pushNamed(context, MainScreen.id);
          },
        ), 
      ),
      body:SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: 10,),
            ProfileMenu(
              text: 'Peronal Information',
              icon: Icon(
                Icons.person_outline_outlined), 
              press: (){
                Navigator.of(context).pop(true);
                Navigator.pushNamed(context, PersonalInfoScreen.id);
              }
            ),
            ProfileMenu(
              text: 'Preferences', 
              icon: Icon(Icons.favorite_outline_rounded), 
              press: (){
                 Navigator.of(context).pop(true);
                 Navigator.pushNamed(context, Preference.id);
              }
            ),
            ProfileMenu(
              text: 'History', 
              icon: Icon(Icons.history), 
              press: (){
                Navigator.of(context).pop(true);
                Navigator.pushNamed(context, History.id);
              }
            ),
            ProfileMenu(
              text: 'Change password', 
              icon: Icon(Icons.security_outlined) ,
              press: (){
                Navigator.of(context).pop(true);
                Navigator.pushNamed(context, ChangePassword.id);
              }
            ),
            ProfileMenu(
              text: 'Signout', 
              icon: Icon(Icons.logout), 
              press: (){
                Navigator.of(context).pop(true);
                Navigator.pushNamed(context, LoginPage.id);
              }
            )
          ],
        ),
      ),
    ),
  );      
}
}