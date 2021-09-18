import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/user/LoginScreen.dart';
import 'profile.dart';

class ChangePassword extends StatefulWidget {
  //final TextEditingController _passwordController = TextEditingController();
  //String get _password => _passwordController.text;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
   //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //key: _formKey,
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
          child: Form(
            key: _formkey,
            child: Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 70),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  TextFormField(
                    controller: oldpassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your old password';
                      }
                      return null;
                    },
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      labelText: "Old Password",
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
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  //For new password
                  TextFormField(
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a new password';
                      }else{
                        if (value.length < 6) {
                          return "Password is too short (minimum is 6 characters)";
                        }
                      
                      //   if (!RegExp(
                      //     r'^(?=.*[A-Z])$')
                      //       .hasMatch(value)) {
                      //       return "Password should contain at least one upper case";
                      //       }
                      
                      //   if (!RegExp(
                      //     r'^(?=.*[a-z])$')
                      //       .hasMatch(value)) {
                      //       return "Password should contain at least one lower case";
                      //       }
                      
                      //   if (!RegExp(
                      //     r'^(?=.*?[0-9])$')
                      //       .hasMatch(value)) {
                      //       return "Password should contain at least one digit";
                      //       }
                        
                      //   if (!RegExp(
                      //     r'^(?=.*?[!@#\$&*~])$')
                      //       .hasMatch(value)) {
                      //       return "Password should contain at least one Special character";
                      //       }
                       }
                      return null;
                    },
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      labelText: "New Password",
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
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  //to confirm password
                  TextFormField(
                    controller: confirmpassword,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please re-enter the new password';
                      }
                      print(password.text);
                      print(confirmpassword.text);
                      if(password.text!=confirmpassword.text){
                        return "Password does not match";
                      }
                      return null;
                    },
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
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
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  //Buttons
                  Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          button(
                              text: 'Change Password',
                              onPressed: () {
                                if(_formkey.currentState!.validate())
                                  {
                                    print("successful");
                                    return;
                                  }else{
                                    print("UnSuccessfull");
                                  }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => LoginScreen()));
                              },
                              color: Colors.teal.shade900),
                          SizedBox(
                            height: 20,
                          ),
                          button(
                              text: 'Cancel',
                              color: Colors.red.shade900,
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage()));
                              })
                        ],
                      ))
                ],
              ),
            )),
        )));
  }
  Widget button({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) =>
      Container(
        height: 40,
        width: 200,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
            style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0),
              ),
              onPrimary: Colors.white,
              shadowColor: Colors.blueGrey,
              elevation: 10,
            )),
      );
}

              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(
              //       height: 15,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
              //       child: TextFormField(
              //         controller: password,
              //         keyboardType: TextInputType.text,
              //         decoration:buildInputDecoration(Icons.lock,"Password"),
                      
              //         validator: (value){
              //           if(value!.isEmpty)
              //           {
              //             return 'Please a Enter Password';
              //           }
              //           return null;
              //         },
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
              //       child: TextFormField(
              //         controller: confirmpassword,
              //         obscureText: true,
              //         keyboardType: TextInputType.text,
              //         decoration:buildInputDecoration(Icons.lock,"Confirm Password"),
              //         validator: (value){
              //           if(value!.isEmpty)
              //           {
              //             return 'Please re-enter password';
              //           }
              //           print(password.text);
              //           print(confirmpassword.text);
              //           if(password.text!=confirmpassword.text){
              //             return "Password does not match";
              //           }
              //           return null;
              //         },
              //       ),
              //     ),
              //     SizedBox(
              //       width: 200,
              //       height: 50,
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(50.0),
              //             side: BorderSide(color: Colors.blue,width: 2)
              //         ),
              //         //textColor:Colors.white,
              //           primary: Colors.redAccent,
              //         ),
                      
              //         onPressed: (){
              //           if(_formkey.currentState!.validate())
              //           {
              //             print("successful");
              //             return;
              //           }else{
              //             print("UnSuccessfull");
              //           }
              //         }, child: Text("Submit"),
                      
              //         ),
              //     )
              //   ],
  //             // ),
  //           ),
  //         ),
  //       ),
  //     );
    
  // }
//   InputDecoration buildInputDecoration(IconData icons,String hinttext) {
//   return InputDecoration(
//     hintText: hinttext,
//     prefixIcon: Icon(icons),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25.0),
//       borderSide: BorderSide(
//           color: Colors.green,
//           width: 1.5
//       ),
//     ),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25.0),
//       borderSide: BorderSide(
//         color: Colors.blue,
//         width: 1.5,
//       ),
//     ),
//     enabledBorder:OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25.0),
//       borderSide: BorderSide(
//         color: Colors.blue,
//         width: 1.5,
//       ),
//     ),
//   );
// }



          
  

