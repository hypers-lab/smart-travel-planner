import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_travel_planner/screens/MainScreen.dart';
import '../../Constants.dart';
import '../MainScreen.dart';
import 'sign_in_with_social_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ResetScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //check box default value
  bool checkboxValue = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _email = "";
  String _password = "";

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          child: Center(
                            child: Text(
                              "Smart Travel \nPlanner",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //Enter via social networks
                Container(
                  height: height * 0.1,
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        loginSocialNetMsg,
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[grayValue]),
                      ),
                    ),
                  ),
                ),

                // google and mac button
                Container(
                  child: SocialNetwork(),
                ),
                //login with email msg
                Container(
                  height: height * 0.1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      loginEmailMsg,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.grey[grayValue],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextFormField(
                                key: const Key('EmailTextFormField'),
                                style: TextStyle(color: Colors.black),
                                validator: (email) {
                                  if (email!.isEmpty) {
                                    return "Email Address is Empty";
                                  } else {
                                    if (!RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(email)) {
                                      return "It's not a valid email";
                                    }
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email or Phone number",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _email = value.trim();
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: const Key('PasswordTextFormField'),
                                style: TextStyle(color: Colors.black),
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return "password is  empty";
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    _password = value.trim();
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: height * 0.05,
                        width: width - 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //Remember me checkbox
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Checkbox(
                                      value: checkboxValue,
                                      onChanged: (value) {
                                        setState(() {
                                          this.checkboxValue = value!;
                                        });
                                      }),
                                  Text(
                                    rememberMe,
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.grey[grayValue],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            //Forget password button
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResetScreen()));
                                },
                                child: Text(
                                  forgotText,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[grayValue],
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        width: 300,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            key: const Key('LoginButton'),
                            onPressed: () {
                              signIn();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            createMsg,
                            style: GoogleFonts.nunitoSans(
                                color: Colors.grey[grayValue],
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: const Text(
                              signUp,
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> signIn() async {
    final formState = formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } on FirebaseAuthException catch (e) {
        print(e.code);

        if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("The password is incorrect")));
        } else if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("The email address is incorrect")));
        }
      }
    }
  }
}
