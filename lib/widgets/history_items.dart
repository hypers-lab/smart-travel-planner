import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget infoHistoryContent({
    required String hotelName,
    required String city,
    required String address,
    required String introduction,
    required String reviewScore,
    required VoidCallback tap,
  }) =>
      GestureDetector(
        onTap: tap ,
        child: Container(
          width: 800,
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            elevation: 15,
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: content(title: 'Place', body: '$hotelName')),
                  SizedBox(height:10),
                  Divider(height: 20,thickness: 3,),
                  Center(child: content(title: 'About', body: '$introduction')),
                  SizedBox(height:10),
                  Divider(height: 20,thickness: 3,),
                  Center(child: content(title: 'City', body: '$city')),
                  SizedBox(height:10),
                  Divider(height: 20,thickness: 3,),
                  Center(child: content(title: 'Address', body: '$address')),
                  SizedBox(height:10),
                  Divider(height: 20,thickness: 3,),
                  Center(child: content(title: 'Review score', body: '$reviewScore')),
                  SizedBox(height:10),
                ],),
            )
            
          ),
        ),
      );
    Widget content({
      required String title,
      required String body,
    })=> Column(
      children: [
        Text(
          title,
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green[900]
          )
        ),
        SizedBox(height:8),
        Text(
          body,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            color:Colors.green[700],
            fontSize: 15,
          )
        ),
      ],
    );