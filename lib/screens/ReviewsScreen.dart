import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/PlaceReview.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
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

    reviewData = await TravelDestination.getReviewHsitoryofUser();

    setState(() {
      if (reviewData.isNotEmpty) {
        isFetching = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('visitedInformation')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
              );
            }));
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
}
