import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_travel_planner/appBrain/PlaceReview.dart';
import 'package:smart_travel_planner/screens/places/details.dart';

class ReviewListTile extends StatelessWidget {
  const ReviewListTile(this.placeReview);

  final PlaceReview placeReview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(placeReview.travelDestination.city, //place city
                style: TextStyle(color: Colors.grey[500])),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Details(
                            place: placeReview.travelDestination,
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.location_city),
                  splashColor: Colors.yellow,
                ),
                Text(placeReview.travelDestination.placeName), //place name
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  RatingBar.builder(
                    itemSize: 25,
                    initialRating: double.parse(
                        placeReview.userReview.reviewScore), //rating
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(width: 50),
                  Row(
                    children: [
                      Text(
                        placeReview.userReview.reviewScore, //rating
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '/ 5.0',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(placeReview.userReview.comment), //comment
            ),
          ],
        ),
      ),
    );
  }
}
