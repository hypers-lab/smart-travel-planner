import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../MainScreen.dart';
import '../../Constants.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String email;
  final String password;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController optController1 = TextEditingController();
  TextEditingController optController2 = TextEditingController();
  TextEditingController optController3 = TextEditingController();
  TextEditingController optController4 = TextEditingController();
  TextEditingController optController5 = TextEditingController();
  TextEditingController optController6 = TextEditingController();

  late FocusNode pin1;
  late FocusNode pin2;
  late FocusNode pin3;
  late FocusNode pin4;
  late FocusNode pin5;

  Color cardColor = Colors.black;

  @override
  void initState() {
    super.initState();
    pin1 = FocusNode();
    pin2 = FocusNode();
    pin3 = FocusNode();
    pin4 = FocusNode();
    pin5 = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1.dispose();
    pin2.dispose();
    pin3.dispose();
    pin4.dispose();
    pin5.dispose();
  }

  void nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void verifyOTP() async {
    String otpCode =
        '${optController1.text}${optController2.text}${optController3.text}${optController4.text}${optController5.text}${optController6.text}';

    try {
      var res =
          EmailAuth.validate(receiverMail: widget.email, userOTP: otpCode);
      if (res) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.email, password: widget.password);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please check your OTP code',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      await FirebaseAuth.instance.currentUser!.delete();
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(
                'Verification',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: width * 0.1,
              height: height * 0.1,
              child: Image(
                image: AssetImage('assets/lock.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Text(
                  'Please enter the verification code \n we sent to your email address',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(color: Colors.grey[grayValue]),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: width - 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: width * 0.1,
                        child: TextFormField(
                          controller: optController1,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onChanged: (value) {
                            nextField(value: value, focusNode: pin1);
                          },
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: width * 0.1,
                        child: TextFormField(
                          controller: optController2,
                          focusNode: pin1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cardColor),
                            ),
                          ),
                          onChanged: (value) {
                            nextField(value: value, focusNode: pin2);
                          },
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: width * 0.1,
                        child: TextFormField(
                          controller: optController3,
                          focusNode: pin2,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cardColor),
                            ),
                          ),
                          onChanged: (value) {
                            nextField(value: value, focusNode: pin3);
                          },
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: width * 0.1,
                        child: TextFormField(
                          controller: optController4,
                          focusNode: pin3,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cardColor),
                            ),
                          ),
                          onChanged: (value) {
                            nextField(value: value, focusNode: pin4);
                          },
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: width * 0.1,
                        child: TextFormField(
                          controller: optController5,
                          focusNode: pin4,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cardColor),
                            ),
                          ),
                          onChanged: (value) {
                            nextField(value: value, focusNode: pin5);
                          },
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: width * 0.1,
                        child: TextFormField(
                          controller: optController6,
                          focusNode: pin5,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cardColor),
                            ),
                          ),
                          onChanged: (value) {
                            pin5.unfocus();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                  onPressed: verifyOTP,
                  style: ElevatedButton.styleFrom(primary: Colors.transparent),
                  child: Text(
                    "Verify",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            //send verification code
            TextButton(
                onPressed: () async {
                  EmailAuth.sessionName = "Hyperslab";
                  await EmailAuth.sendOtp(receiverMail: widget.email);
                },
                child: Text('Try again', style: GoogleFonts.nunitoSans()))
          ],
        ),
      ),
    );
  }
}
