import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class UserReview {
  UserReview(
      {required this.userId, required this.reviewScore, required this.comment});

  final String userId;
  final String reviewScore;
  final String comment;
}
