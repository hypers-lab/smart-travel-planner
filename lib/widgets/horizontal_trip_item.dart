import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/TripInformation.dart';
import 'package:smart_travel_planner/screens/itenerary/IteneraryScreen.dart';
import 'package:smart_travel_planner/screens/places/TripDetails.dart';
import 'package:intl/intl.dart';

class HorizontalTripItem extends StatelessWidget {
  final TripInformation trip;

  HorizontalTripItem(this.trip);

  getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return DateFormat(dateFormat).format(docDateTime);
  }

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
                  child: Image.memory(
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
                  trip.trip.tripName,
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
                width: 115,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        getCustomFormattedDateTime(
                            trip.trip.date.toString(), 'yyyy-MM-dd'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          color: Colors.blueGrey[300],
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      width: 35,
                      child: IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Colors.blue,
                        iconSize: 20,
                        onPressed: () {
                          // Send them to your email maybe?
                          var tripName = trip.trip.tripName;
                          DateTime now = DateTime.now();
                          String userdId = TravelDestination.getCurrentUserId();

                          //adding to firebase
                          CollectionReference trips =
                              FirebaseFirestore.instance.collection('trips');
                          trips.add({
                            'tripName': tripName,
                            'date': now,
                            'status': 0,
                            'userId': userdId,
                            'image': trip.trip.places[5].travelDestination
                                .photoReference,
                            'places': trip.trip.places
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IteneraryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
                  trip: trip.trip,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
