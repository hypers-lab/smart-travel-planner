import 'package:flutter/material.dart';

Widget button({
  required String text,
  required VoidCallback onPressed,
  required Color color,
}) =>
    Container(
      height: 40,
      width: 100,
      child: ElevatedButton(
        key: Key("saveButton"),
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          onPrimary: Colors.white,
          shadowColor: Colors.blueGrey,
          elevation: 10,
        ),
      ),
    );
