import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import '../MainScreen.dart';

Future<void> signInWithGoogle(context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLogoutEnable = true;
  if (isLogoutEnable) {
    await googleSignIn.signOut();
  }
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((_) async {
      String uid = TravelDestination.getCurrentUserId();
      print(uid);

      //adding to firebase
      final userSnapShot = await FirebaseFirestore.instance
          .collection('userPreferences')
          .doc(uid) // varuId in your case
          .get();

      if (!userSnapShot.exists) {
        CollectionReference userPreferencesRef =
            FirebaseFirestore.instance.collection('userPreferences');
        await userPreferencesRef
            .doc(uid)
            .set({"preferredAreas": [], "preferredTypes": []}).then((value) {});
      }

      final profileSnapShot = await FirebaseFirestore.instance
          .collection('user_personal_information')
          .doc(uid) // varuId in your case
          .get();

      if (!profileSnapShot.exists) {
        CollectionReference userPersonalInformationRef =
            FirebaseFirestore.instance.collection('user_personal_information');
        await userPersonalInformationRef.doc(uid).set({
          "age": 0,
          "gender": "",
          "img_url": "",
          "name": "",
          "phone_number": ""
        }).then((value) {});
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    });
  } catch (e) {
    print(e.toString());
  }
}



//mac




