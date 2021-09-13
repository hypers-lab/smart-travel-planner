import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<void> signInWithApple() async {
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account.

  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    webAuthenticationOptions: WebAuthenticationOptions(
      clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
      redirectUri: Uri.parse(
        'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
      ),
    ),
    nonce: 'example-nonce',
    state: 'example-state',
  );

  // Create an `OAuthCredential` from the credential returned by Apple.
  OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  final signInWithAppleEndpoint = Uri(
    scheme: 'https',
    host: 'flutter-sign-in-with-apple-example.glitch.me',
    path: '/sign_in_with_apple',
    queryParameters: <String, String>{
      'code': appleCredential.authorizationCode,
      if (appleCredential.givenName != null)
        'firstName': appleCredential.givenName!,
      if (appleCredential.familyName != null)
        'lastName': appleCredential.familyName!,
      'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
      if (appleCredential.state != null) 'state': appleCredential.state!,
    },
  );

  final session = await http.Client().post(
    signInWithAppleEndpoint,
  );

  print(session);
}


//https://smart-travel-planner-e5cf1.firebaseapp.com/__/auth/handler