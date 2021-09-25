import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/CustomAppBar.dart';
import '../widgets/horizontal_place_item.dart';
import '../widgets/icon_badge.dart';
import '../widgets/search_bar.dart';
import '../widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.places);
  final List<TravelDestination> places;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<TravelDestination> places = widget.places;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:10.0,left: 20.0, right: 20.0, bottom: 20.0),
            child: Text(
              "Where are you \ngoing?",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SearchBar(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Suggested Travel Places",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildHorizontalList(context),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Recently Visited",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildHorizontalList(context),
          buildVerticalList(),
        ],
      ),
    );
  }

  buildHorizontalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        // ignore: unnecessary_null_comparison
        itemCount: places == null ? 0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = places.reversed.toList()[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildVerticalList() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // ignore: unnecessary_null_comparison
        itemCount: places == null ? 0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = places[index];
          return VerticalPlaceItem(place);
        },
      ),
    );
  }
}
