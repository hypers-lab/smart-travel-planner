import 'package:flutter/material.dart';
import 'package:smart_travel_planner/widgets/edit_personal_info_widget.dart';
import 'profile.dart';

class EditProfilePage extends StatefulWidget {
  static const String id = 'editProfilePage';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit your Personal Info...',
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop(true);
            Navigator.pushNamed(context, ProfilePage.id);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [const SizedBox(height: 30), EditPersonalInfoItem()],
            ),
          )
        ],
      ),
    );
  }
}
