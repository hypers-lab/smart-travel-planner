import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';


class History extends StatelessWidget {
  
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Travelling History'),
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
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/pic.jpg'),
                fit: BoxFit.cover,),
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child:Stack (children: <Widget>[
            TextField(
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15.0),
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
              hintText: "Search by date or place",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
            maxLines: 1,
            controller: _searchControl,
            ),
          ])
        ),
      ),
    );
  }
}
