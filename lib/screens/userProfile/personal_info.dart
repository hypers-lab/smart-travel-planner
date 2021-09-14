import 'package:flutter/material.dart';
import 'edit_personal_info.dart';
import 'profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  static const String id = 'personalInfo';
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop(true);
            Navigator.pushNamed(context, ProfilePage.id);
          },
        ),
        title: Text('Account Personal Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          infoContent(information: 'Sarah@gmail.com', title: 'Email'),
          infoContent(information: '', title: 'Name'),
          infoContent(information: '', title: 'Age'),
          infoContent(information: '', title: 'Phone Number'),
          infoContent(information: '', title: 'Gender'),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pushNamed(context, EditProfilePage.id);
                },
                child: Text(
                  'Edit Personal Info',
                  style: TextStyle(),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  primary: Colors.teal[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPrimary: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                ),
              )),
        ],
      )),
    );
  }

  Widget infoContent({
    required String information,
    required String title,
  }) =>
      Card(
        elevation: 10,
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          title: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800),
            ),
          ),
          subtitle: Center(
            child: Text(
              information,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
}
