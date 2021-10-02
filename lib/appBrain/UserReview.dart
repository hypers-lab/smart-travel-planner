class UserReview {
  UserReview(
      {required this.placeId,
      required this.userId,
      required this.reviewScore,
      required this.comment});

  final int placeId;
  final String userId;
  final String reviewScore;
  final String comment;
}
