import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/screens/places/TripDetails.dart';

class HorizontalTripItem extends StatelessWidget {
  final Trip trip;

  HorizontalTripItem(this.trip);

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
                  child: Image.network(
                    trip.image,
                    height: 150.0,
                    width: 120.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  trip.tripName,
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
                  trip.date.toString(),
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
          //final List<TravelDestination> suggestions =TravelDestination.getSuggestedPlacesFromModel(place.placeId) as List<TravelDestination>;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return TripDetails(
                  trip: trip,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
