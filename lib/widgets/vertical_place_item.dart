import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/screens/places/details.dart';

class VerticalPlaceItem extends StatelessWidget {
  final PlaceInformation place;

  VerticalPlaceItem(this.place);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        child: Container(
          height: 70.0,
          child: Row(
            children: <Widget>[
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.memory(place.image,
                      height: 80.0, width: 80.0, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 15.0),
              Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width - 140.0,
                child: ListView(
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${place.travelDestination.placeName}",
                        overflow: TextOverflow.ellipsis,
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
                          width: MediaQuery.of(context).size.width - 180,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${(place.travelDestination.address=="null")?"Sri Lanka":place.travelDestination.address}",
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ratings: ${(place.travelDestination.rating.toString()=="null")?"No Ratings":place.travelDestination.rating.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          //print(place.travelDestination.placeId);
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
