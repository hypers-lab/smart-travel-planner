import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget infoHistoryContent({
  required String hotelName,
  required String city,
  required String address,
  required String reviewScore,
  required VoidCallback tap,
}) =>
    GestureDetector(
      onTap: tap,
      child: Container(
        width: 800,
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            elevation: 15,
            color: Colors.lime[50],
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.green.shade300, Colors.green.shade100])),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: content(title: 'PLACE', body: '$hotelName')),
                    Divider(
                      height: 30,
                      thickness: 3,
                    ),
                    Center(child: content(title: 'CITY', body: '$city')),
                    Divider(
                      height: 30,
                      thickness: 3,
                    ),
                    Center(child: content(title: 'ADDRESS', body: '$address')),
                    Divider(
                      height: 30,
                      thickness: 3,
                    ),
                    Center(
                        child: content(
                            title: 'REVIEW SCORE', body: '$reviewScore')),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )),
      ),
    );
Widget content({
  required String title,
  required String body,
}) =>
    Column(
      children: [
        Text(title,
            style: GoogleFonts.dmSerifDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green[900])),
        SizedBox(height: 8),
        Text(body,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              color: Colors.green[800],
              fontSize: 15,
            )),
      ],
    );
