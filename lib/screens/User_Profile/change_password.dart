import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/User_Profile/profile.dart';
import 'package:smart_travel_planner/screens/user/login.dart';

class ChangePassword extends StatefulWidget {
  static const String id = 'changePassword';
  const ChangePassword({ Key? key }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar:AppBar(
        title: Text('Change Your Password'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: (){
            Navigator.of(context).pop(true);
            Navigator.pushNamed(context, ProfilePage.id);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 30,right: 30,top: 40),
          child:Align(
            alignment: Alignment.center,
          child:Column(
            children: [
              TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  labelText: "Old Password",
                  border: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 30,),
              TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  
                  labelText: "New Password",
                  border: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.grey[200],
                  ),
                ),
              SizedBox(height: 30,),
              TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.grey[200],
                  ),
                ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    button(
                      text: 'Change Password', 
                      onPressed: () {
                          Navigator.of(context).pop(true);
                          Navigator.pushNamed(context, LoginPage.id);
                        }, 
                        color: Colors.teal.shade900),
                    SizedBox(height: 20,),
                    button(
                      text: 'Cancel', 
                      color: Colors.red.shade900, 
                      onPressed: () {  
                        Navigator.of(context).pop(true);
                        Navigator.pushNamed(context, ProfilePage.id);
                      }
                    )
                  ],
                )
              )
            ],
          ),
        )
      ),
    )
  );
}
  Widget button({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  })=>Container(
        height: 40,
        width: 200,
        child: ElevatedButton(
          onPressed: onPressed, 
          child: Text(text),
          style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),),
          onPrimary: Colors.white,
          shadowColor: Colors.blueGrey,
          elevation: 10,
          )
        ),
      ); 
}