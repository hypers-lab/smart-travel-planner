import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/places/details.dart';

class HorizontalPlaceItem extends StatelessWidget {
  final PlaceInformation place;

  HorizontalPlaceItem(this.place);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7.0),
      child: InkWell(
        child: Container(
          height: 250.0,
          width: 115.0,
          child: Column(
            children: <Widget>[
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(place.image, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  place.travelDestination.placeName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  place.travelDestination.rating.toString(),
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
        ),
        onTap: () {
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
