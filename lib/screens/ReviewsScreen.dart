import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_travel_planner/appBrain/PlaceReview.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/UserReview.dart';
import 'package:smart_travel_planner/widgets/reviewlist_tile.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isFetching = false;
  List<PlaceReview> reviewData = [];

  @override
  void initState() {
    super.initState();
    getReviewData();
  }

  //retrive data of particular user's reviews
  getReviewData() async {
    setState(() {
      isFetching = true;
    });

    final String uid = TravelDestination.getCurrentUserId();

    await FirebaseFirestore.instance
        .collection("visitedInformation")
        .where("userId", isEqualTo: uid)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserReview userReview = UserReview(
            placeId: doc["placeId"],
            userId: uid,
            reviewScore: doc["reviewScore"],
            comment: doc["comment"]);

        FirebaseFirestore.instance
            .collection("hotels")
            .where("hotelId", isEqualTo: userReview.placeId)
            .limit(1)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            TravelDestination travelDestination = TravelDestination(
                city: doc.data()["city"],
                placeId: doc.data()["hotelId"],
                placeName: doc.data()["hotelName"],
                mainPhotoUrl: doc.data()["mainPhotoUrl"],
                reviewScore: doc.data()["reviewScore"].toString(),
                reviewScoreWord: doc.data()["reviewScoreWord"],
                reviewText: doc.data()["reviewText"],
                description: doc.data()["description"],
                coordinates: doc.data()["coordinates"],
                checkin: doc.data()["checkin"],
                checkout: doc.data()["checkout"],
                address: doc.data()["address"],
                url: doc.data()["url"],
                introduction: doc.data()["introduction"]);

            PlaceReview reviewNplace =
                PlaceReview(travelDestination, userReview);

            print(
                "placeName and City: ${reviewNplace.travelDestination.city},${reviewNplace.travelDestination.placeName} ");

            reviewData.add(reviewNplace);
          });
        });
      });

      setState(() {
        (reviewData.isNotEmpty) ? isFetching = false : isFetching = true;
        //isFetching = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: Text(
              "Reviews",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isFetching ? buildDummyTiles(context) : buildVerticalList(context),
        ],
      ),
    );
  }

  //vertical list reviews
  buildVerticalList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reviewData.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceReview placeReview = reviewData[index];
          return ReviewListTile(placeReview);
        },
      ),
    );
  }

  //dummy view
  buildDummyTiles(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
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
                  Text('City', style: TextStyle(color: Colors.grey[500])),
                  Row(
                    children: [
                      Icon(Icons.location_city),
                      Text('Place Name'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        RatingBar.builder(
                          itemSize: 25,
                          initialRating: 3,
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
                              '4.0',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
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
                    child: Text('Comment'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //loading
  // Center(child: CircularProgressIndicator(),)
}
