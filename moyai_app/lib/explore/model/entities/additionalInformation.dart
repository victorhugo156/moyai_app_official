class AdditionalInformation {
  final String infoId;
  final List<String> foodIntoleranceOption;
  final String eptosPortability;
  final String? menuImage1;
  final String? menuImage2;
  final String? menuUrl;
  final String? instagramLink;
  final String? websiteLink;
  final String? facebookLink;
  final String? twitterXLink;
  final String? otherSocialMedia;
  final List<String> websiteFeatures;
  final List<String> websiteAccessibility;
  final String staffTraining;
  final String additionalHelpfulFeatures;
  final String venueLiveEvents;
  final String brokenOrMissingInfo;
  final String createdAt;
  final String updatedAt;

  AdditionalInformation({
    required this.infoId,
    required this.foodIntoleranceOption,
    required this.eptosPortability,
    this.menuImage1,
    this.menuImage2,
    this.menuUrl,
    this.instagramLink,
    this.websiteLink,
    this.facebookLink,
    this.twitterXLink,
    this.otherSocialMedia,
    required this.websiteFeatures,
    required this.websiteAccessibility,
    required this.staffTraining,
    required this.additionalHelpfulFeatures,
    required this.venueLiveEvents,
    required this.brokenOrMissingInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdditionalInformation.fromJson(Map<String, dynamic> json) {
    return AdditionalInformation(
      infoId: json['infoId'],
      foodIntoleranceOption: List<String>.from(json['foodIntoleranceOption'] ?? []),
      eptosPortability: json['eptosPortability'] ?? '',
      menuImage1: json['menuImage1'],
      menuImage2: json['menuImage2'],
      menuUrl: json['menuUrl'],
      instagramLink: json['instagramLink'],
      websiteLink: json['websiteLink'],
      facebookLink: json['facebookLink'],
      twitterXLink: json['twitterXLink'],
      otherSocialMedia: json['otherSocialMedia'],
      websiteFeatures: List<String>.from(json['websiteFeatures'] ?? []),
      websiteAccessibility: List<String>.from(json['websiteAccessibility'] ?? []),
      staffTraining: json['staffTraining'] ?? '',
      additionalHelpfulFeatures: json['additionalHelpfulFeatures'] ?? '',
      venueLiveEvents: json['venueLiveEvents'] ?? '',
      brokenOrMissingInfo: json['brokenOrMissingInfo'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'infoId': infoId,
      'foodIntoleranceOption': foodIntoleranceOption,
      'eptosPortability': eptosPortability,
      'menuImage1': menuImage1,
      'menuImage2': menuImage2,
      'menuUrl': menuUrl,
      'instagramLink': instagramLink,
      'websiteLink': websiteLink,
      'facebookLink': facebookLink,
      'twitterXLink': twitterXLink,
      'otherSocialMedia': otherSocialMedia,
      'websiteFeatures': websiteFeatures,
      'websiteAccessibility': websiteAccessibility,
      'staffTraining': staffTraining,
      'additionalHelpfulFeatures': additionalHelpfulFeatures,
      'venueLiveEvents': venueLiveEvents,
      'brokenOrMissingInfo': brokenOrMissingInfo,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}