import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smart_travel_planner/widgets/button.dart';
import '../screens/userProfile/personal_info.dart';

class EditPersonalInfoItem extends StatefulWidget {
  @override
  _EditPersonalInfoItemState createState() => _EditPersonalInfoItemState();
}

class _EditPersonalInfoItemState extends State<EditPersonalInfoItem> {
  
// for send the details to the server
  late String name;
  late String phonenumber;
  late int age;
  late String gender;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthm = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            //call each widgets which are created seperately
            buildNameFormField(),
            SizedBox(height: 45),
            buildAgeFormField(),
            SizedBox(height: 30),
            buildPhoneNumberFormField(),
            SizedBox(height: 30),
            buildGenderFormField(),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.fromLTRB(
                (widthm - 274) / 2, 20, (widthm - 274) / 2, 0),
              child: Row(
                children: [
                  //cancel button
                  button(
                      key: Key("cancelButton"),
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
                  //save button
                  button(
                    key: Key("saveButton"),
                    text: 'Save',
                    color: Colors.teal.shade900,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('YOUR INFORMATIONS ARE SAVED'),
                          key: Key("snackbarEditPersonalInfo"),
                        ));
                        //call the function to store the details in documents
                        _sendToServer();
                        //navigate to the personal info screen
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
      key: Key("genderField"),
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
      key: Key("phoneNumberField"),
      validator: (value) {
        Key("error-empty-phone-number-field");
        if (value!.length < 10 && value.length > 0) {
          return "Phone number should have 10 numbers";
        } else {
          if (value.isEmpty) {
            return 'Please enter your phone number';
          }
        }
      },
      onSaved: (value) {
        phonenumber = value!;
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
    return TextFormField(
      key: Key("nameField"),
      keyboardType: TextInputType.text,
      onSaved: (value) {
        name = value!;
      },
      validator: (value) {
        Key("error-empty-name-field");
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
      key: Key("ageField"),
      validator: (value) {
        Key("error-empty-age-field");
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
      _formkey.currentState?.save();
      var firebaseUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('user_personal_information')
          .doc(firebaseUser?.uid)
          .update({
        'name': name,
        'age': age,
        'phone_number': phonenumber,
        'gender': gender
      });
    }
  }
}
