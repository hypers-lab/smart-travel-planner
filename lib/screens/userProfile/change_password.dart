import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/user/LoginScreen.dart';
import 'package:smart_travel_planner/widgets/button.dart';
import 'profile.dart';

class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}
class _ChangePasswordState extends State<ChangePassword> {
  // TextEditingController newpassword = TextEditingController();
  // TextEditingController oldpassword = TextEditingController();
  // TextEditingController confirmpassword = TextEditingController();
  String newpassword='';
  String oldpassword='';
  String confirmpassword='';
  
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Change Your Password'),
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ProfilePage()));
                
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/edit2.jpg'),
                  fit: BoxFit.fill)),
            child: Form(
              key: _formkey,
              child: Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 70),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value){
                        oldpassword =value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your old password';
                        }
                      },
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        hintText: "Old Password",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.green[100],
                      ),
                    ),
                    SizedBox(height: 50,),

                    //=======>For new password<==========
                    TextFormField(
                      onSaved:(value){
                        newpassword = value!;
                        },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password';
                        }else{
                          if (value.length < 6) {
                            return "Password is too short (minimum is 6 characters)";
                          }
                        }
                        return null;
                      },
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        hintText: "New Password",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.green[100],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    //===========>To confirm new password<================
                    TextFormField(
                      onSaved:(value){
                        confirmpassword = value!;
                        },
                      validator: (value){
                        if(value!.isEmpty)
                        {return 'Please re-enter the new password';}
                        if(newpassword!=confirmpassword){
                          return "Password does not match";
                        }
                        return null;
                      },
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.green[100],
                      ),
                    ),
                    SizedBox(height: 40,),

                    //Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Row(
                        children: [
                          button(
                            text: 'Cancel',
                            color: Colors.red.shade900,
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                builder: (context) => ProfilePage()
                                )
                              );
                            }
                          ),
                          SizedBox(width: 10,),
                          button(
                            color: Colors.teal.shade900,
                            text: 'Save',
                              onPressed: () {
                                
                                if(_formkey.currentState!.validate() ){
                                  //No error in validator
                                  _formkey.currentState!.save();
                                   _changePassword();
                                 
                                }   
                              }, 
                            ),
                          ],
                      )
                    )
                  ],
                ),
              )
            ),
          ),
        )
      )
    );
  }
  
 void _changePassword() async {

   var firebaseUser =  FirebaseAuth.instance.currentUser;
    String email =firebaseUser!.email.toString();print(email);

    //pass the password here
    String password = oldpassword;
    String newPassword = newpassword;

    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
      
      firebaseUser.updatePassword(newPassword).then((_){
        print("Successfully changed password");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password has been changed, Please login with your new password'),)) ;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }).catchError((error){
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ypur old password is incorrect, Please enter your old password correctly'),)) ;
      }
    }
  }
}
                    
