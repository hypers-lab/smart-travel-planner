import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../MainScreen.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    await FirebaseAuth.instance.signInWithCredential(credential).then((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    });
  } catch (e) {
    print(e.toString());
  }
}



//mac




