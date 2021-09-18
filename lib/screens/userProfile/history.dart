import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';
import 'package:smart_travel_planner/widgets/search_bar.dart';

class History extends StatelessWidget {
  
 
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Travelling History',
        ),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
        
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.blueGrey[300],
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "      Search by date or place",
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
          ),
          maxLines: 1,
          controller: _searchControl,
        ),
    ),
      )
    );
  }
}
