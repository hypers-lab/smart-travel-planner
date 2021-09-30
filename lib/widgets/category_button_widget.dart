import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {required this.buttonFunc,
      required this.buttonIcon,
      required this.buttonColor,
      required this.iconColor});

  final Function buttonFunc;
  final IconData buttonIcon;
  final Color iconColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      autofocus: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      onPressed: () {
        buttonFunc();
        print('Button Clicked.');
      },
      color: buttonColor,
      padding: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Icon(
          buttonIcon,
          color: iconColor,
          size: 40,
        ),
      ),
    );
  }
}
