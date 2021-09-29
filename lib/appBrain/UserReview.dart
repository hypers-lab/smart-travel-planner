class UserReview {
  UserReview(
      {required this.placeId,
      required this.userId,
      required this.reviewScore,
      required this.comment});

  final int placeId;
  final String userId;
  final double reviewScore;
  final String comment;
}
