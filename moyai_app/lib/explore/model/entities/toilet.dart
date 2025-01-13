class Toilet {
  final String toiletId;
  final List<String>? locationOfToilet;
  final List<String>? toiletClassifications;
  final List<String>? toiletUsage;
  final List<String>? accessibilityFeatures;
  final List<String>? distanceToToilet;
  final int? entryWidth;
  final int? stallDoorWidth;
  final int? stallToiletClearanceCm;
  final List<String>? toiletHeight;
  final List<String>? basinHeight;
  final List<String>? toiletLighting;
  final List<String>? floorSpaceInToilet;
  final String? toiletImage1;
  final String? describeToiletImage1;
  final String? whereClosestToiletIs;
  final bool? isJourneyToToiletFlat;
  final List<String>? railLocation;
  final List<String>? rampFeatures;
  final List<String>? stairsFeatures;
  final List<String>? escalatorType;
  final List<String>? entryToToilet;
  final List<String>? tactileIndicator;
  final String? toiletImage2;
  final String? describeToiletImage2;
  final String? toiletServiceAreaVideo;
  final String? stairsImage;
  final String? stairsImageDescribe;
  final List<String>? liftFeatures;
  final String? rampImage;
  final String? rampImageDescribe;


  Toilet({
    required this.toiletId,
    this.locationOfToilet,
    this.toiletClassifications,
    this.toiletUsage,
    this.accessibilityFeatures,
    this.distanceToToilet,
    this.entryWidth,
    this.stallDoorWidth,
    this.stallToiletClearanceCm,
    this.toiletHeight,
    this.basinHeight,
    this.toiletLighting,
    this.floorSpaceInToilet,
    this.toiletImage1,
    this.describeToiletImage1,
    this.whereClosestToiletIs,
    this.isJourneyToToiletFlat,
    this.railLocation,
    this.rampFeatures,
    this.stairsFeatures,
    this.escalatorType,
    this.entryToToilet,
    this.tactileIndicator,
    this.toiletImage2,
    this.describeToiletImage2,
    this.toiletServiceAreaVideo,
    this.stairsImage,
    this.stairsImageDescribe,
    this.liftFeatures,
    this.rampImage,
    this.rampImageDescribe,

  });

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
      toiletId: json['toiletId'],
      locationOfToilet: List<String>.from(json['locationOfToilet'] ?? []),
      toiletClassifications: List<String>.from(json['toiletClassifications'] ?? []),
      toiletUsage: List<String>.from(json['toiletUsage'] ?? []),
      accessibilityFeatures: List<String>.from(json['accessibilityFeature'] ?? []),
      distanceToToilet: List<String>.from(json['distanceToToilet'] ?? [])
      , // Assuming first value in list
      entryWidth: json['entryWidth'],
      stallDoorWidth: json['stallDoorWidth'],
      stallToiletClearanceCm: json['stallToiletClearanceCm'],
      toiletHeight: List<String>.from(json['height'] ?? []),
      basinHeight: List<String>.from(json['basinHeight'] ?? []),
      toiletLighting: List<String>.from(json['toiletLightning'] ?? []),
      floorSpaceInToilet: List<String>.from(json['floorSpaceInToilet'] ?? []),
      toiletImage1: json['toiletImage1'],
      describeToiletImage1: json['describeToiletImage1'],
      whereClosestToiletIs: json['whereClosestToiletIs'],
      isJourneyToToiletFlat: json['isJourneyToToiletFlat'] == "true",
      railLocation: List<String>.from(json['railLocation'] ?? []),
      rampFeatures: List<String>.from(json['rampFeatures'] ?? []),
      stairsFeatures: List<String>.from(json['stairsFeatures'] ?? []),
      escalatorType: List<String>.from(json['escalatorType'] ?? []),
      entryToToilet: List<String>.from(json['entryToToilet'] ?? []),
      tactileIndicator: List<String>.from(json['tactileIndicator'] ?? []),
      toiletImage2: json['toiletImage2'],
      describeToiletImage2: json['describeToiletImage2'],
      toiletServiceAreaVideo: json['toiletServiceAreaVideo'],
      stairsImage: json['stairsImage'],
      stairsImageDescribe: json['stairsImageDescribe'],
      liftFeatures: List<String>.from(json['liftFeatures'] ?? []),
      rampImage: json['rampImage'],
      rampImageDescribe: json['rampImageDescribe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toiletId': toiletId,
      'locationOfToilet': locationOfToilet,
      'toiletClassifications': toiletClassifications,
      'toiletUsage': toiletUsage,
      'accessibilityFeature': accessibilityFeatures,
      'distanceToToilet': distanceToToilet,
      'entryWidth': entryWidth,
      'stallDoorWidth': stallDoorWidth,
      'stallToiletClearanceCm': stallToiletClearanceCm,
      'height': toiletHeight,
      'basinHeight': basinHeight,
      'toiletLightning': toiletLighting,
      'floorSpaceInToilet': floorSpaceInToilet,
      'toiletImage1': toiletImage1,
      'describeToiletImage1': describeToiletImage1,
      'whereClosestToiletIs': whereClosestToiletIs,
      'isJourneyToToiletFlat': isJourneyToToiletFlat,
      'railLocation': railLocation,
      'rampFeatures': rampFeatures,
      'stairsFeatures': stairsFeatures,
      'escalatorType': escalatorType,
      'entryToToilet': entryToToilet,
      'tactileIndicator': tactileIndicator,
      'toiletImage2': toiletImage2,
      'describeToiletImage2': describeToiletImage2,
      'toiletServiceAreaVideo': toiletServiceAreaVideo,
      'stairsImage': stairsImage,
      'stairsImageDescribe': stairsImageDescribe,
      'liftFeatures': liftFeatures,
      'rampImage': rampImage,
      'rampImageDescribe': rampImageDescribe,

    };
  }
}