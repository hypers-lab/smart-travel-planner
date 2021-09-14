import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/home.dart';
import 'package:smart_travel_planner/screens/main_screen.dart';
import 'screens/User_Profile/profile.dart';
import 'screens/user/login.dart';
import 'util/const.dart';
import 'package:smart_travel_planner/routes.dart';
import 'screens/user/create_account.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      initialRoute: ProfilePage.id,
      routes: routes,
    );
  }
}
