import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails {
  UserDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.phonenumber,
  });

  String name;
  int age;
  int phonenumber;
  String gender;

 
  //get user details from server
  void getUserDetails() {
    final String uid = getCurrentUserId();
     try{FirebaseFirestore.instance
        .collection('user_personal_information')
        .doc(uid)
        .get()
        .then((value) {
      UserDetails user = UserDetails(
          name: value.get('name'),
          age: value.get('age'),
          gender: value.get('gender'),
          phonenumber: value.get('phone number'));

    });
     }catch (e) {
      print("Data Fetch Error:$e");
    }
    
  }
  //get Current user's id
  static String getCurrentUserId() {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user!.uid;
      return uid;
    } catch (e) {
      print('Firebase Authorization failed!');
    }
    return "";
  }

//store user details
  void sendToServer() {
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

