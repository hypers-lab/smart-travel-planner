import 'package:smart_travel_planner/appBrain/UserReview.dart';
import 'package:test/test.dart';

void main() {
  group('UserReview:', () {
    test('UserReview object should be created.', () {
      UserReview userReview = UserReview(
          comment: "Great place to visit!",
          reviewScore: "4.0",
          userId: "rDmvYdBXHWfcQmSViTSJKADycpf2");

      expect(userReview.comment, "Great place to visit!");
      expect(userReview.reviewScore, "4.0");
      expect(userReview.userId, "rDmvYdBXHWfcQmSViTSJKADycpf2");
    });
  });
}
