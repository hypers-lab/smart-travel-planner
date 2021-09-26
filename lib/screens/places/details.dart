import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/screens/places/MapViewerScreen.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'package:smart_travel_planner/widgets/review_form.dart';

class Details extends StatefulWidget {
  static const String id = 'details';

  Details({required this.place, required this.suggestedPlaces});

  final TravelDestination place;
  final List<TravelDestination>
      suggestedPlaces; //Holds the list of places that suggested from the model

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late TravelDestination place = widget.place;
  late List<TravelDestination> suggestedPlaces = widget.suggestedPlaces;

  final _formKey = GlobalKey<FormState>();

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
                    heroTag: "btn1",
                    child: Icon(
                      Icons.reviews,
                      size: 25,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.orangeAccent,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
                                // ignore: deprecated_member_use
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Positioned(
                                    right: -40.0,
                                    top: -40.0,
                                    child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.close),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                  ReviewForm(formKey: _formKey),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    heroTag: "btn2",
                    child: Icon(
                      Icons.map_sharp,
                      size: 30,
                      color: Colors.lime,
                    ),
                    backgroundColor: Colors.blueGrey,
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
              SizedBox(height: 5),
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
        },
      ),
    );
  }
}
