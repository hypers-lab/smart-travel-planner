import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/screens/places/MapViewerScreen.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import '../../widgets/icon_badge.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';

class Details extends StatelessWidget {
  Details(this.place);
  final TravelDestination place;

  //retrieve sugggested places based on selected place
  List places = TravelDestination.getPlacesDetailsDummy(); //dummy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications_none,
              color: Colors.amber,
              size: 24.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
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
                        "${place.placeName}",
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
                      "${place.address}, ${place.city}",
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
                '${place.introduction}',
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
        itemCount: places == null ? 0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          TravelDestination place = places.reversed.toList()[index];
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
            padding: EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                "$imgUrl",
                height: 250.0,
                width: MediaQuery.of(context).size.width - 40.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
