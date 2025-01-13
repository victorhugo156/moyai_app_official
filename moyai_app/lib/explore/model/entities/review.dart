import 'package:moyai_app/profile/model/User.dart';

class Review {
  final String reviewID;
  final int stars;
  final String reviewText;
  final DateTime createdAt;
  final ReviewUser user;

  Review(
      {required this.reviewID,
      required this.stars,
      required this.reviewText,
      required this.createdAt,
      required this.user});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewID: json['reviewId'] ?? '',
      stars: json['stars'] ?? 0,
      reviewText: json['reviewText'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
      user: ReviewUser.fromJson(json['user'] ?? {}),
    );
  }
}



class ReviewUser {
  final String userId;
  final String firstName;
  final String lastName;
  final String? profileImage;

  ReviewUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  // Factory constructor to create a User from JSON
  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      userId: json['id'] ?? '',
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? 'User',
      profileImage: json['profileImage'],
    );
  }
}
