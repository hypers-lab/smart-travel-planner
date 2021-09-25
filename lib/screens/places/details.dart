import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/screens/CustomAppBar.dart';
import 'package:smart_travel_planner/screens/places/MapViewerScreen.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';

class Details extends StatelessWidget {
  Details({required this.place, required this.suggestions});
  final TravelDestination place;
  final List
      suggestions; //Holds the list of places that suggested from the model

  //retrieve sugggested places based on selected place
  List<TravelDestination> suggestedPlaces =
      TravelDestination.getPlacesDetailsDummy(); //dummy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          buildSlider(),
          SizedBox(height: 20),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        place.placeName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    child: Icon(
                      Icons.map,
                      size: 25,
                      color: Colors.deepOrangeAccent,
                    ),
                    backgroundColor: Colors.amber,
                    onPressed: () {
                      PlaceLocation visitPlace = PlaceLocation(
                          coordinates: place.coordinates,
                          placeName: place.placeName);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapViewScreen(visitPlace)),
                      );
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.blueGrey[300],
                  ),
                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${place.address},\n${place.city}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\u{2B50} ${place.reviewScore.toString()} \u{1F4AD} ${place.reviewText}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\u{27A1}${place.checkin}\n\u{2B05}${place.checkout}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
              ReadMoreText(
                '${place.description}',
                trimLines: 2,
                colorClickableText: Colors.deepOrange,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' ...View more',
                trimExpandedText: ' Less',
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
              SizedBox(height: 10.0),
            ],
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Suggested Travel Places",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          buildHorizontalList(context),
          SizedBox(height: 10.0)
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
        itemCount: suggestedPlaces == null ? 0 : suggestedPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = suggestedPlaces.reversed.toList()[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildSlider() {
    List imageSliderUrls = [place.mainPhotoUrl];
    return Container(
      padding: EdgeInsets.only(left: 20),
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        // ignore: unnecessary_null_comparison
        itemCount: imageSliderUrls == null ? 0 : imageSliderUrls.length,
        itemBuilder: (BuildContext context, int index) {
          String imgUrl = imageSliderUrls[index];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 40.0,
              height: 250.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                image: new DecorationImage(
                  image: new NetworkImage(place.mainPhotoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

          // return Padding(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(10.0),
          //     child: Image.network(
          //       imgUrl,
          //       height: 250.0,
          //       width: MediaQuery.of(context).size.width - 40.0,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
