import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? image;
  bool isFetching = false;
  Image? finalImage;
  late String imgurl;
  late String imgURL;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    asignimage();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      sendDataToStorage();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  sendDataToStorage() async {
    var path = image!.path;
    var storageImage =
        FirebaseStorage.instance.ref().child('profile_pictures/$path');
    var uploadtask = storageImage.putFile(image!);

    await uploadtask.whenComplete(() async {
      try {
        imgurl = await storageImage.getDownloadURL();
      } catch (onError) {
        print("Error");
      }
      _sendToServer();
    });
  }

  _sendToServer() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user_personal_information')
        .doc(firebaseUser!.uid)
        .update({'img_url': imgurl.toString()});
  }

  asignimage() async {
    setState(() {
      isFetching = true;
    });

    var firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('user_personal_information')
          .doc(firebaseUser!.uid)
          .get()
          .then((value) {
        imgURL = value.get('img_url');
        //print(imgURL);
        if (imgURL.isNotEmpty) {
          return finalImage = Image.network(imgURL);
        }
      });
    } catch (e) {
      print('Firebase getting img url is failed!');
    }
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 115,
        width: 115,
        child: Stack(fit: StackFit.expand, clipBehavior: Clip.none, children: [
          isFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : finalImage != null
                  ? ClipOval(
                      child: Image.network(
                        imgURL,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                      'assets/Profile.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    )),
          Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: buildEditIcon(
                      color: Colors.green.shade200,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(20, 170, 20, 360),
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.green[50],
                                elevation: 20,
                                child: Container(
                                  child: ListView(
                                    //shrinkWrap: true,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(20),
                                            primary: Colors.grey[800],
                                          ),
                                          onPressed: () =>
                                              pickImage(ImageSource.gallery),
                                          child: Text(
                                            'Choose from gallery',
                                            style: TextStyle(fontSize: 17),
                                          )),
                                      SizedBox(height: 5),
                                      Divider(
                                        height: 5,
                                        thickness: 2,
                                        color: Colors.black,
                                      ),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(20),
                                            primary: Colors.grey[800],
                                          ),
                                          onPressed: () =>
                                              pickImage(ImageSource.camera),
                                          child: Text(
                                            'Use your camera',
                                            style: TextStyle(fontSize: 17),
                                          )),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })))
        ]));
  }

  Widget buildEditIcon({
    required Color color,
    required VoidCallback onPressed,
  }) =>
      buildCircle(
        color: Colors.white,
        all: 1,
        child: buildCircle(
          color: color,
          all: 0.01,
          child: IconButton(
              splashColor: Colors.grey,
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onPressed),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          height: 30,
          width: 30,
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
