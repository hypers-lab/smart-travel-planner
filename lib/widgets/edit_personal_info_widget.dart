import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smart_travel_planner/appBrain/user.dart';
import 'package:smart_travel_planner/widgets/button.dart';
import '../screens/userProfile/personal_info.dart';

class EditPersonalInfoItem extends StatefulWidget {
  @override
  _EditPersonalInfoItemState createState() => _EditPersonalInfoItemState();
}

class _EditPersonalInfoItemState extends State<EditPersonalInfoItem> {
  void initState() {
    super.initState();
    getUserDetails();
  }

// for send the details to the server
  late String name;
  late int phonenumber;
  late int age;
  late String gender;

//Recieve the details from server
  late String username = '';
  late String userphonenumber = '';
  late String userage = '';
  late String usergender;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            buildNameFormField(),
            SizedBox(height: 45),
            buildAgeFormField(),
            SizedBox(height: 30),
            buildPhoneNumberFormField(),
            SizedBox(height: 30),
            buildGenderFormField(),
            SizedBox(height: 40),
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
                                builder: (context) => PersonalInfoScreen()));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  button(
                    text: 'Save',
                    color: Colors.teal.shade900,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('YOUR INFORMATIONS ARE SAVED'),
                        ));
                        _sendToServer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalInfoScreen()));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form builder for gender
  FormBuilderDropdown buildGenderFormField() {
    return FormBuilderDropdown(
      name: "gender",
      //initialValue: usergender,
      onSaved: (value) {
        gender = value!;
      },
      validator: (value) => value == null ? 'Select your gender' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.green[100],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      hint: Text('Select Gender'),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text('$gender'),
              ))
          .toList(),
    );
  }

  //TextForm builder for phone number
  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      //initialValue: userphonenumber,
      validator: (value) {
        if (value!.length < 10 && value.length > 0) {
          return "Phone number should have 10 numbers";
        } else {
          if (value.isEmpty) {
            return 'Please enter your phone number';
          }
        }
      },
      onSaved: (value) {
        phonenumber = int.tryParse(value!)!;
      },
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        new LengthLimitingTextInputFormatter(10)
      ],

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: "Enter your phone number",
        filled: true,
        fillColor: Colors.green[100],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // TextForm builder for name
  TextFormField buildNameFormField() {
    print('Username:$username');
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: username,
      onSaved: (value) {
        name = value!;
      },
      validator: (value) {
        if (value!.length > 100 && value.isNotEmpty) {
          return "Enter a valid name";
        } else {
          if (value.isEmpty) {
            return 'Please enter you name';
          }
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: "Enter your name",
        filled: true,
        fillColor: Colors.green[100],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  //TextForm builder for age
  TextFormField buildAgeFormField() {
    return TextFormField(
      //initialValue: userage,
      validator: (value) {
        var numValue = int.tryParse(value!);
        if (value.isNotEmpty && numValue! < 6) {
          return "Age should be greater than 5";
        } else {
          if (value.isEmpty) {
            return 'Please enter your age';
          }
        }
      },
      onSaved: (value) {
        age = int.tryParse(value!)!;
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: 2,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: "Enter your age",
        filled: true,
        fillColor: Colors.green[100],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // to update the informations of current user to firestore
  _sendToServer() {
    if (_formkey.currentState!.validate()) {
      //No error in validator
      _formkey.currentState!.save();
      var firebaseUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('user_personal_information')
          .doc(firebaseUser!.uid)
          .update({
        'name': name,
        'age': age,
        'phone number': phonenumber,
        'gender': gender
      });
    }
  }

  //get current user's information from firestore
  Future getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('user_personal_information')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      UserDetails user = UserDetails(
          name: value.get('name'),
          age: value.get('age'),
          gender: value.get('gender'),
          phonenumber: value.get('phone number'));

      username = user.name;
      userage = user.age.toString();
      userphonenumber = user.phonenumber.toString();
      usergender = user.gender;
    });
    print('Mine is $username,$userage,$userphonenumber,$usergender');
    //return 'Fetching error';
  }
}
