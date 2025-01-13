class OptionForAccess {
  final String accessId;
  final String? rampWidth;
  final String? rampLength;
  final String? imageOfRamp;
  final List<String> railsOnRamp;
  final List<String> railsOnSteps;
  final List<String> rampFeatures;
  final String? numberOfSteps;
  final List<String> rampForAccess;
  final String? entranceDoorCm;
  final String? otherObstacles;
  final List<String> featuresOfSteps;
  final List<String> optionsForAccessDescription;
  final List<String> entranceFeatures;
  final List<String> liftForThisAccess;
  final List<String> signageAndDirection;
  final List<String> stepsForThisAccess;
  final String? rampDegreeMeasurement;
  final List<String> escalatorForThisAccess;
  final List<String> obstaclesWithTheAccess;
  final String? imageOfStairsForThisAccess;
  final bool? isThereObstaclesWithThisAccess;
  final String createdAt;
  final String updatedAt;

  OptionForAccess({
    required this.accessId,
    this.rampWidth,
    this.rampLength,
    this.imageOfRamp,
    required this.railsOnRamp,
    required this.railsOnSteps,
    required this.rampFeatures,
    this.numberOfSteps,
    required this.rampForAccess,
    this.entranceDoorCm,
    this.otherObstacles,
    required this.featuresOfSteps,
    required this.optionsForAccessDescription,
    required this.entranceFeatures,
    required this.liftForThisAccess,
    required this.signageAndDirection,
    required this.stepsForThisAccess,
    this.rampDegreeMeasurement,
    required this.escalatorForThisAccess,
    required this.obstaclesWithTheAccess,
    this.imageOfStairsForThisAccess,
    this.isThereObstaclesWithThisAccess,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OptionForAccess.fromJson(Map<String, dynamic> json) {
    return OptionForAccess(
      accessId: json['accessId'],
      rampWidth: json['rampWidth'],
      rampLength: json['rampLength'],
      imageOfRamp: json['imageOfRamp'],
      railsOnRamp: List<String>.from(json['railsOnRamp'] ?? []),
      railsOnSteps: List<String>.from(json['railsOnSteps'] ?? []),
      rampFeatures: List<String>.from(json['rampFeatures'] ?? []),
      numberOfSteps: json['numberOfSteps'],
      rampForAccess: List<String>.from(json['rampForAccess'] ?? []),
      entranceDoorCm: json['entranceDoorCm'],
      otherObstacles: json['otherObstacles'],
      featuresOfSteps: List<String>.from(json['featuresOfSteps'] ?? []),
      optionsForAccessDescription: List<String>.from(json['optionsForAccessDescription'] ?? []),
      entranceFeatures: List<String>.from(json['entranceFeatures'] ?? []),
      liftForThisAccess: List<String>.from(json['liftForThisAccess'] ?? []),
      signageAndDirection: List<String>.from(json['signageAndDirection'] ?? []),
      stepsForThisAccess: List<String>.from(json['stepsForThisAccess'] ?? []),
      rampDegreeMeasurement: json['rampDegreeMeasurement'],
      escalatorForThisAccess: List<String>.from(json['escalatorForThisAccess'] ?? []),
      obstaclesWithTheAccess: List<String>.from(json['obstaclesWithTheAccess'] ?? []),
      imageOfStairsForThisAccess: json['imageOfStairsForThisAccess'],
      isThereObstaclesWithThisAccess: json['isThereObstaclesWithThisAccess'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessId': accessId,
      'rampWidth': rampWidth,
      'rampLength': rampLength,
      'imageOfRamp': imageOfRamp,
      'railsOnRamp': railsOnRamp,
      'railsOnSteps': railsOnSteps,
      'rampFeatures': rampFeatures,
      'numberOfSteps': numberOfSteps,
      'rampForAccess': rampForAccess,
      'entranceDoorCm': entranceDoorCm,
      'otherObstacles': otherObstacles,
      'featuresOfSteps': featuresOfSteps,
      'optionsForAccessDescription': optionsForAccessDescription,
      'entranceFeatures': entranceFeatures,
      'liftForThisAccess': liftForThisAccess,
      'signageAndDirection': signageAndDirection,
      'stepsForThisAccess': stepsForThisAccess,
      'rampDegreeMeasurement': rampDegreeMeasurement,
      'escalatorForThisAccess': escalatorForThisAccess,
      'obstaclesWithTheAccess': obstaclesWithTheAccess,
      'imageOfStairsForThisAccess': imageOfStairsForThisAccess,
      'isThereObstaclesWithThisAccess': isThereObstaclesWithThisAccess,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static List<OptionForAccess> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OptionForAccess.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<OptionForAccess> options) {
    return options.map((option) => option.toJson()).toList();
  }
}