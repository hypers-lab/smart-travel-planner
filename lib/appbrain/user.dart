import 'package:firebase_auth/firebase_auth.dart';

class User {
  User({
    required this.name,
    required this.age,
    required this.gender,
    required this.phonenumber,
  });

  String name;
  String age;
  String phonenumber;
  String gender;

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'gender': gender,
        'phone number': phonenumber,
      };
}
