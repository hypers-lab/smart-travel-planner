import 'package:flutter/widgets.dart';
import 'package:smart_travel_planner/screens/main_screen.dart';
import 'screens/user/create_account.dart';
import 'screens/user/login.dart';
import 'screens/user/forgot_password.dart';
import 'screens/main_screen.dart';
import 'screens/home.dart';
import 'screens/details.dart';

final Map<String, WidgetBuilder> routes = {
  CreateAccountPage.id: (context) => CreateAccountPage(),
  LoginPage.id: (context) => LoginPage(),
  ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
  MainScreen.id: (context) => MainScreen(),
  Home.id: (context) => Home(),
  Details.id: (context) => Details(),
};
