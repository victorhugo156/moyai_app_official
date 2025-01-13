import 'package:moyai_app/explore/model/entities/option_for_access.dart';
import 'package:moyai_app/explore/model/entities/toilet.dart';
import 'package:moyai_app/explore/model/entities/venueEnvironments.dart';

import 'accessibility.dart';
import 'additionalInformation.dart';
import 'dashboard_analytics.dart';

class VenueDetail {
  final Toilet? toilets;
  final List<DashboardAnalytics>? dashboardAnalytics;
  final Accessibility? accessibility;
  final VenueEnvironments? venueEnvironments;
  final AdditionalInformation? additionalInformation;
  final List<OptionForAccess>? optionForAccess;
  final UserReview? userReview;

  VenueDetail({
    this.toilets,
    this.dashboardAnalytics,
    this.accessibility,
    this.venueEnvironments,
    this.additionalInformation,
    this.optionForAccess,
    this.userReview,
  });

  factory VenueDetail.fromJson(Map<String, dynamic> json) {
    return VenueDetail(
      toilets: json['venue']['toilet'] != null
          ? Toilet.fromJson(json['venue']['toilet'])
          : null,
      dashboardAnalytics: json['venue']['dashboardAnalytics'] != null
          ? (json['venue']['dashboardAnalytics'] as List)
          .map((item) => DashboardAnalytics.fromJson(item))
          .toList()
          : [],
      accessibility: json['venue']['accessibility'] != null
          ? Accessibility.fromJson(json['venue']['accessibility'])
          : null,
      venueEnvironments: json['venue']['venueEnvironments'] != null
          ? VenueEnvironments.fromJson(json['venue']['venueEnvironments'])
          : null,
      additionalInformation: json['venue']['additionalInformation'] != null
          ? AdditionalInformation.fromJson(json['venue']['additionalInformation'])
          : null,
        optionForAccess: json['venue']['optionsForAccess'] != null
            ? (json['venue']['optionsForAccess'] as List)
            .map((item) => OptionForAccess.fromJson(item))
            .toList()
            : [],

      userReview: json['userReview']  != null
          ? UserReview.fromJson(json['userReview'])
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toilets': toilets?.toJson(),
      'dashboardAnalytics': dashboardAnalytics?.map((item) => item.toJson()).toList(),
      'accessibility': accessibility?.toJson(),
      'venueEnvironments': venueEnvironments?.toJson(),
      'additionalInformation': additionalInformation?.toJson(),
      'optionsForAccess': optionForAccess?.map((item) => item.toJson()).toList(),
    };
  }
}

class UserReview {
  final String reviewID;
  final int stars;
  final String reviewText;
  final DateTime createdAt;
 

  UserReview(
      {required this.reviewID,
        required this.stars,
        required this.reviewText,
        required this.createdAt,
        });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      reviewID: json['reviewId'] ?? '',
      stars: json['stars'] ?? 0,
      reviewText: json['reviewText'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
