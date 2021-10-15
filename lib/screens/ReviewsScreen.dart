import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/PlaceReview.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/UserReview.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/util/const.dart';
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

  var googlePlace = GooglePlace(GOOGLE_API_KEY);

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

    await FirebaseFirestore.instance
        .collection("visitedPlaces")
        .where("reviewScore", isNotEqualTo: 0.0)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc["placeName"]);

        TravelDestination travelDestination = TravelDestination(
            businessStatus: doc["businessStatus"],
            placeId: doc["placeId"],
            placeName: doc["placeName"],
            photoReference: doc["photoReference"],
            rating: doc["rating"],
            userRatingsTotal: doc["userRatingsTotal"],
            latitude: doc["latitude"],
            longitude: doc["longitude"],
            description: doc["description"],
            openStatus: doc["openStatus"],
            address: doc["address"]);

        UserReview userReview = UserReview(
            userId: doc["userId"],
            reviewScore: doc["reviewScore"].toString(),
            comment: doc["comment"]);

        //default image
        Uint8List image =
            (await rootBundle.load('assets/default_place_image.jpg'))
                .buffer
                .asUint8List();

        var imageResult = await this
            .googlePlace
            .photos
            .get(travelDestination.photoReference, 0, 400);
        if (imageResult != null) {
          image = imageResult;
        }

        PlaceInformation placeInformation =
            PlaceInformation(travelDestination, image);

        PlaceReview reviewNplace = PlaceReview(placeInformation, userReview);

        print(
            "placeName and City: ${reviewNplace.place.travelDestination.placeName}");

        reviewData.add(reviewNplace);

        setState(() {
          isFetching = false;
        });
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
