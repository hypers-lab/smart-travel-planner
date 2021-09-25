import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';

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
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(Icons.account_circle_rounded,size: 30.0,),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: PopupMenuButton<String>(
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
        ),
      ],
    );
  }
}
