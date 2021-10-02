import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/MainScreen.dart';

import '../screens/places/details.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

import 'icon_badge.dart';

class VerticalTripPlaceItem extends StatelessWidget {
  final TravelDestination place;

  VerticalTripPlaceItem(this.place);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 320.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network("${place.mainPhotoUrl}",
                      height: 80.0, width: 80.0, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 15.0),
              Container(
                width: 210,
                child: ListView(
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${place.placeName}",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 13.0,
                          color: Colors.blueGrey[300],
                        ),
                        SizedBox(width: 3.0),
                        Container(
                          width: MediaQuery.of(context).size.width - 200,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${place.address}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          Transform.scale(
                            scale: 0.8,
                            child: IconButton(
                              padding: new EdgeInsets.all(0.0),
                              icon: Icon(Icons.arrow_upward),
                              color: Colors.red,
                              iconSize: 25,
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Transform.scale(
                            scale: 0.8,
                            child: IconButton(
                              padding: new EdgeInsets.all(0.0),
                              icon: Icon(Icons.arrow_downward),
                              color: Colors.red,
                              iconSize: 25,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                iconSize: 20,
                onPressed: () {},
              ),
            ],
          ),
        ),
        onTap: () {
          //final List<TravelDestination> suggestions =TravelDestination.getSuggestedPlacesFromModel(place.placeId) as List<TravelDestination>;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Details(
                  place: place,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
