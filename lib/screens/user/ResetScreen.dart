import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants.dart';

//import 'package:pdf_to_text_app/Screen/sign_in_with_social_network.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  //check box default value
  bool checkboxValue = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _email = "";

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: height * 0.15,
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        resetText,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 35, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: Text(
                      'Please enter the email address.',
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.nunitoSans(color: Colors.grey[grayValue]),
                    ),
                  ),
                ),

                //Email TextField
                Container(
                  height: height * 0.1,
                  width: width - 50,
                  child: TextFormField(
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
                        hintText: "Email",
                        labelStyle: GoogleFonts.nunitoSans(
                            fontSize: 22, color: Colors.black),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),

                //send request button
                Container(
                  height: height * 0.1,
                  width: width - 50,
                  child: Center(
                    child: SizedBox(
                      height: height * 0.08,
                      width: width - 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        onPressed: () {
                          auth.sendPasswordResetEmail(email: _email);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "We send link for reset password.Please check your email")));
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          resetButton,
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
