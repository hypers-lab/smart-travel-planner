import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_with_social_network.dart';
import '../../Constants.dart';
import 'VerifyScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //check box default value
  bool checkBoxValue = false;
  String msg = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String get _password => _passwordController.text;
  String get _email => _emailController.text;

  final auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          //form key
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
              //sign up with email
              Container(
                height: height * 0.1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    signUpMsg,
                    style: GoogleFonts.nunitoSans(
                        color: Colors.grey[grayValue],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //Email TextField
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
                              controller: _emailController,
                              //validator
                              validator: (email) {
                                if (email == null || email.isEmpty) {
                                  return "Please enter email";
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
                            ),
                          ),

                          //Password TextField
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _passwordController,
                              //validation
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return "Please enter the password";
                                } else {
                                  if (password.length < 6) {
                                    return "Password is too short (minimum is 6 characters)";
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              obscureText: true,
                            ),
                          ),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //privacy Policy checkbox
                          Container(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                    activeColor: Colors.blue,
                                    value: checkBoxValue,
                                    onChanged: (value) {
                                      setState(() {
                                        this.checkBoxValue = value!;
                                      });
                                    }),
                                Text(
                                  privacy,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    //sign up button
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
                          onPressed: sendOTP,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent),
                          child: Text(
                            "Sign Up",
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
                    //Sign up button
                    Container(
                      height: height * 0.07,
                      width: width - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
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
                                      builder: (context) => LoginScreen()));
                            },
                            child: const Text(
                              login,
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendOTP() async {
    if (formKey.currentState!.validate()) {
      if (checkBoxValue) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password);

          FirebaseAuth.instance.currentUser!.delete();
          FirebaseAuth.instance.signOut();

          //send otp code
          print(_email);
          EmailAuth.sessionName = "Hyperslab";
          var res = await EmailAuth.sendOtp(receiverMail: _email);
          if (res) {
            print('otp sent');
            //verify screen navigate
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  email: _email,
                  password: _password,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'OTP code was not sent, Please try again',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'The account already exists for that email.',
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
          print(e.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please accept terms & conditions ',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    }
  }
}
