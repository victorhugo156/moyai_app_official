class VenueEnvironments {
  final String environmentId;
  final List<String> venueLightning;
  final String? imageOfLightning;
  final String? imageOfLightningDescribe;
  final String? imageOfLightning2;
  final List<String> visualAccessibility;
  final double avgDecibelReading;
  final double maxDecibelReading;
  final String timeOfReading;
  final List<String> soundCharacteristics;
  final String? otherSounds;
  final String? recordingDiningAreaSound;
  final List<String> hearingAccessibility;
  final String? flooring;
  final String? imageOfServingArea;
  final String? imageOfServingAreaDescribe;
  final String? imageOfServingArea2;
  final String? imageOfServingArea2Describe;
  final List<String> smell;
  final String? otherSmells;
  final List<String> temperature;
  final List<String> visualStimulation;
  final String? imageOfVisualOverwhelm;
  final String? imageOfVisualOverwhelmDescribe;
  final String? imageOfVisualOverwhelm2;
  final List<String> overwhelmManagement;
  final String? animalsWelcome;
  final String createdAt;
  final String updatedAt;

  VenueEnvironments({
    required this.environmentId,
    required this.venueLightning,
    this.imageOfLightning,
    this.imageOfLightningDescribe,
    this.imageOfLightning2,
    required this.visualAccessibility,
    required this.avgDecibelReading,
    required this.maxDecibelReading,
    required this.timeOfReading,
    required this.soundCharacteristics,
    this.otherSounds,
    this.recordingDiningAreaSound,
    required this.hearingAccessibility,
    this.flooring,
    this.imageOfServingArea,
    this.imageOfServingAreaDescribe,
    this.imageOfServingArea2,
    this.imageOfServingArea2Describe,
    required this.smell,
    this.otherSmells,
    required this.temperature,
    required this.visualStimulation,
    this.imageOfVisualOverwhelm,
    this.imageOfVisualOverwhelmDescribe,
    this.imageOfVisualOverwhelm2,
    required this.overwhelmManagement,
    this.animalsWelcome,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VenueEnvironments.fromJson(Map<String, dynamic> json) {
    return VenueEnvironments(
      environmentId: json['environmentId'],
      venueLightning: List<String>.from(json['venueLightning']),
      imageOfLightning: json['imageOfLightning'],
      imageOfLightningDescribe: json['imageOfLightningDescribe'],
      imageOfLightning2: json['imageOfLightning2'],
      visualAccessibility: List<String>.from(json['visualAccessibility']),
      avgDecibelReading: double.tryParse(json['avgDecibelReading']) ?? 0.0,
      maxDecibelReading: double.tryParse(json['maxDecibelReading']) ?? 0.0,
      timeOfReading: json['timeOfReading'],
      soundCharacteristics: List<String>.from(json['soundCharacteristics']),
      otherSounds: json['otherSounds'],
      recordingDiningAreaSound: json['recordingDiningAreaSound'],
      hearingAccessibility: List<String>.from(json['hearingAccessibility']),
      flooring: json['flooring'],
      imageOfServingArea: json['imageOfServingArea'],
      imageOfServingAreaDescribe: json['imageOfServingAreaDescribe'],
      imageOfServingArea2: json['imageOfServingArea2'],
      imageOfServingArea2Describe: json['imageOfServingArea2Describe'],
      smell: List<String>.from(json['smell']),
      otherSmells: json['otherSmells'],
      temperature: List<String>.from(json['temperature']),
      visualStimulation: List<String>.from(json['visualStimulation']),
      imageOfVisualOverwhelm: json['imageOfVisualOverwhelm'],
      imageOfVisualOverwhelmDescribe: json['imageOfVisualOverwhelmDescribe'],
      imageOfVisualOverwhelm2: json['imageOfVisualOverwhelm2'],
      overwhelmManagement: List<String>.from(json['overwhelmManagement']),
      animalsWelcome: json['animalsWelcome'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environmentId': environmentId,
      'venueLightning': venueLightning,
      'imageOfLightning': imageOfLightning,
      'imageOfLightningDescribe': imageOfLightningDescribe,
      'imageOfLightning2': imageOfLightning2,
      'visualAccessibility': visualAccessibility,
      'avgDecibelReading': avgDecibelReading,
      'maxDecibelReading': maxDecibelReading,
      'timeOfReading': timeOfReading,
      'soundCharacteristics': soundCharacteristics,
      'otherSounds': otherSounds,
      'recordingDiningAreaSound': recordingDiningAreaSound,
      'hearingAccessibility': hearingAccessibility,
      'flooring': flooring,
      'imageOfServingArea': imageOfServingArea,
      'imageOfServingAreaDescribe': imageOfServingAreaDescribe,
      'imageOfServingArea2': imageOfServingArea2,
      'imageOfServingArea2Describe': imageOfServingArea2Describe,
      'smell': smell,
      'otherSmells': otherSmells,
      'temperature': temperature,
      'visualStimulation': visualStimulation,
      'imageOfVisualOverwhelm': imageOfVisualOverwhelm,
      'imageOfVisualOverwhelmDescribe': imageOfVisualOverwhelmDescribe,
      'imageOfVisualOverwhelm2': imageOfVisualOverwhelm2,
      'overwhelmManagement': overwhelmManagement,
      'animalsWelcome': animalsWelcome,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}