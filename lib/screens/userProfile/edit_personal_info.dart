import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/userProfile/personal_info.dart';
import 'package:smart_travel_planner/widgets/edit_personal_info_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        centerTitle: true,
        title: Text(
          'Edit your Personal Info...',
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonalInfoScreen()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/edit2.jpg'), fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [const SizedBox(height: 70), EditPersonalInfoItem()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
