//the repeating widget content of body
  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget infoContent({
    required String information,
    required String title,
  }) =>
      Card(
        key: Key("personalInfo"),
        elevation: 15,
        color: Colors.green[100],
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          title: Center(
            child: Text(
              title,
              style: GoogleFonts.dmSerifDisplay(
                  fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: 1),
            ),
          ),
          subtitle: Center(
            child: Text(
              information,
              style: GoogleFonts.shadowsIntoLight(
                  fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 3),
            ),
          ),
        ),
      );