import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/HomeScreen.dart';
import 'package:smart_travel_planner/screens/user/LoginScreen.dart';
import 'util/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/MainScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
    );
  }
}
