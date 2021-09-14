import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/User_Profile/profile.dart';
import 'package:smart_travel_planner/widgets/search_bar.dart';

class History extends StatelessWidget {
  const History({ Key? key }) : super(key: key);
  static const String id = 'history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Travelling History',),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: (){
            Navigator.of(context).pop(true);
            Navigator.pushNamed(context, ProfilePage.id);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SearchBar(),
      ),
    );
  }
}
 