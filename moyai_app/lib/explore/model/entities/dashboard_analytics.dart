class DashboardAnalytics {
  final String analyticsId;
  final int checkIns;
  final int reviews;
  final String feedback;
  final int views;
  final int savedToFavorites;
  final int informationAccuracyThumbsUp;
  final int informationAccuracyThumbsDown;
  final String createdAt;
  final String updatedAt;

  DashboardAnalytics({
    required this.analyticsId,
    required this.checkIns,
    required this.reviews,
    required this.feedback,
    required this.views,
    required this.savedToFavorites,
    required this.informationAccuracyThumbsUp,
    required this.informationAccuracyThumbsDown,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    return DashboardAnalytics(
      analyticsId: json['analyticsId'],
      checkIns: json['checkIns'],
      reviews: json['reviews'],
      feedback: json['feedback'],
      views: json['views'],
      savedToFavorites: json['savedToFavorites'],
      informationAccuracyThumbsUp: json['informationAccuracyThumbsUp'],
      informationAccuracyThumbsDown: json['informationAccuracyThumbsDown'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analyticsId': analyticsId,
      'checkIns': checkIns,
      'reviews': reviews,
      'feedback': feedback,
      'views': views,
      'savedToFavorites': savedToFavorites,
      'informationAccuracyThumbsUp': informationAccuracyThumbsUp,
      'informationAccuracyThumbsDown': informationAccuracyThumbsDown,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}