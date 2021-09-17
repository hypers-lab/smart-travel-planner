import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/places/MapViewScreen.dart';
import 'package:smart_travel_planner/util/location.dart';
import '../../widgets/icon_badge.dart';

class Details extends StatelessWidget {
  Details(this.place);
  final place;

  static const String id = 'details';

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
          Container(
            padding: EdgeInsets.only(left: 20),
            height: 250.0,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "${place["image_url"]}",
                  height: 250.0,
                  width: MediaQuery.of(context).size.width - 40.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
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
                        "${place["name"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bookmark,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 25,
                    color: Colors.blueGrey[300],
                  ),
                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${place["place"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                  "${place["rating"]}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 40),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${place["description"]}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.map,
          size: 25,
        ),
        onPressed: () {
          PlaceLocation visitPlace =
              PlaceLocation(place["coordinates"][0], place["coordinates"][1]);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapViewScreen(visitPlace)),
          );
        },
      ),
    );
  }

  // buildSlider() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 20),
  //     height: 250.0,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       primary: false,
  //       // ignore: unnecessary_null_comparison
  //       itemCount: places == null ? 0 : places.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         Map place = places[index];
  //
  //         return Padding(
  //           padding: EdgeInsets.only(right: 10.0),
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(10.0),
  //             child: Image.network(
  //               "${place["image_url"]}",
  //               height: 250.0,
  //               width: MediaQuery.of(context).size.width - 40.0,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
