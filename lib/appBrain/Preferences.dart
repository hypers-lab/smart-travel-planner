import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPreferences {
  UserPreferences({
    required this.types,
    required this.areas,
  });

  List types;
  List areas;

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
 
  //get user details from server
  void getUserPreferences() {
    final String uid = getCurrentUserId();
     try{
      FirebaseFirestore.instance
        .collection('userPreferences')
        .doc(uid)
        .get()
        .then((value) {
      UserPreferences userPreferences = UserPreferences(
          types: value.get('preferredTypes'),
          areas: value.get('preferredAreas'),);
          print(userPreferences);
    });
    }catch (e) {
      print("Data Fetch Error:$e");
    }
    
  }
 
//store user details
  void sendToServer() {
    final String uid = getCurrentUserId();
    FirebaseFirestore.instance
        .collection('userPreferences')
        .doc(uid)
        .update({
          'preferredTypes': types,
          'preferredAreas': areas,
      });
    }
  }

