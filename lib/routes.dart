import 'package:flutter/widgets.dart';
import 'screens/user/create_account.dart';
import 'screens/user/login.dart';
import 'screens/user/forgot_password.dart';

final Map<String, WidgetBuilder> routes = {
  CreateAccountPage.id: (context) => CreateAccountPage(),
  LoginPage.id: (context) => LoginPage(),
  ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
};
