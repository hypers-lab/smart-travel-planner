import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../screens/userProfile/personal_info.dart';

class EditPersonalInfoItem extends StatefulWidget {
  @override
  _EditPersonalInfoItemState createState() => _EditPersonalInfoItemState();
}

class _EditPersonalInfoItemState extends State<EditPersonalInfoItem> {
  final _formKey = GlobalKey<FormState>();
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  late String name;
  late String phoneNumber;
  late String age;
  late String gender;
  TextEditingController textController = TextEditingController();
  //ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildNameFormField(),
            SizedBox(height: 30),
            buildAgeFormField(),
            SizedBox(height: 30),
            buildPhoneNumberFormField(),
            SizedBox(height: 30),
            buildGenderFormField(),
            SizedBox(height: 30),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Row(
                children: [
                  button(
                      text: 'Cancel',
                      color: Colors.red.shade900,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        Navigator.pushNamed(context, PersonalInfoScreen.id);
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  button(
                    text: 'Save',
                    color: Colors.teal.shade900,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.pushNamed(context, PersonalInfoScreen.id);
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

  FormBuilderDropdown buildGenderFormField() {
    return FormBuilderDropdown(
      name: "gender",
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: "Gender",
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onSaved: (newValue) => gender = newValue!,
      hint: Text('Select Gender'),
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(context)]),
      // initialValue: 'Male',
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text('$gender'),
              ))
          .toList(),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        new LengthLimitingTextInputFormatter(10)
      ],
      onSaved: (newValue) => phoneNumber = newValue!,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        filled: true,
        fillColor: Colors.grey[200],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      ],
      onSaved: (newValue) => name = newValue!,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: "Name",
        hintText: "Enter your name",
        filled: true,
        fillColor: Colors.grey[200],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAgeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      maxLength: 2, // Only numbers can be entered
      onSaved: (newValue) => age = newValue!,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: "Age",
        hintText: "Enter your age",
        filled: true,
        fillColor: Colors.grey[200],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget button({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) =>
      Container(
        height: 40,
        width: 100,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
          style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPrimary: Colors.white,
            shadowColor: Colors.blueGrey,
            elevation: 10,
          ),
        ),
      );
}
