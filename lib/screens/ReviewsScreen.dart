import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List<UserReview> userReviewsData = [];

  @override
  void initState() {
    super.initState();
    getReviewData();
  }

  //retrive data of particular user's reviews
  Future<void> getReviewData() async {
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
            reviewScore: doc["reviewScore"].toString(),
            comment: doc["comment"]);

        userReviewsData.add(userReview);
      });
    });

    for (var userReview in userReviewsData) {
      await FirebaseFirestore.instance
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

          PlaceReview reviewNplace = PlaceReview(travelDestination, userReview);

          print(
              "placeName and City: ${reviewNplace.travelDestination.city},${reviewNplace.travelDestination.placeName} ");

          reviewData.add(reviewNplace);
          setState(() {
            isFetching = false;
          });
        });
      });
    }
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
          isFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildVerticalList(context),
        ],
      ),
    );
  }

  //vertical list of reviews
  buildVerticalList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
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
}
