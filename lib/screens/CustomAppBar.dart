import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Hi,Dulaj',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          PopupMenuButton<String>(
            iconSize: 100.0,
            elevation: 3.2,
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}
