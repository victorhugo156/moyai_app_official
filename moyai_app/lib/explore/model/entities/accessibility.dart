class Accessibility {
  final String accessibilityId;
  final List<String> insideFeatures;
  final List<String> flooring;
  final List<String> roomToMove;
  final String? diningAreaImage1;
  final String? describeDiningAreaImage1;
  final String? diningAreaImage2;
  final String? describeDiningAreaImage2;
  final List<ChairMeasurement> chairMeasurements;
  final List<TableMeasurement> tableMeasurements;
  final List<String> escalatorType;
  final String? escalatorImage;
  final String? describeEscalatorImage;
  final List<String> liftFeature;
  final String? liftImage;
  final String? describeLiftImage;
  final List<String> stairsFeatures;
  final String? stairImage;
  final String? describeStairsImage;
  final List<String> rampFeature;
  final String? rampImage;
  final String? describeRampImage;

  Accessibility({
    required this.accessibilityId,
    required this.insideFeatures,
    required this.flooring,
    required this.roomToMove,
    this.diningAreaImage1,
    this.describeDiningAreaImage1,
    this.diningAreaImage2,
    this.describeDiningAreaImage2,
    required this.chairMeasurements,
    required this.tableMeasurements,
    required this.escalatorType,
    this.escalatorImage,
    this.describeEscalatorImage,
    required this.liftFeature,
    this.liftImage,
    this.describeLiftImage,
    required this.stairsFeatures,
    this.stairImage,
    this.describeStairsImage,
    required this.rampFeature,
    this.rampImage,
    this.describeRampImage,
  });

  factory Accessibility.fromJson(Map<String, dynamic> json) {
    return Accessibility(
      accessibilityId: json['accessibilityId'],
      insideFeatures: List<String>.from(json['insideFeatures']),
      flooring: List<String>.from(json['flooring']),
      roomToMove: List<String>.from(json['roomToMove']),
      diningAreaImage1: json['diningAreaImage1'],
      describeDiningAreaImage1: json['describeDiningAreaImage1'],
      diningAreaImage2: json['diningAreaImage2'],
      describeDiningAreaImage2: json['describeDiningAreaImage2'],
      chairMeasurements: (json['chairMeasurements'] as List)
          .map((e) => ChairMeasurement.fromJson(e))
          .toList(),
      tableMeasurements: (json['tableMeasurements'] as List)
          .map((e) => TableMeasurement.fromJson(e))
          .toList(),
      escalatorType: List<String>.from(json['escalatorType']),
      escalatorImage: json['escalatorImage'],
      describeEscalatorImage: json['describeEscalatorImage'],
      liftFeature: List<String>.from(json['liftFeature']),
      liftImage: json['liftImage'],
      describeLiftImage: json['describeLiftImage'],
      stairsFeatures: List<String>.from(json['stairsFeatures']),
      stairImage: json['stairImage'],
      describeStairsImage: json['describeStairsImage'],
      rampFeature: List<String>.from(json['rampFeature']),
      rampImage: json['rampImage'],
      describeRampImage: json['describeRampImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessibilityId': accessibilityId,
      'insideFeatures': insideFeatures,
      'flooring': flooring,
      'roomToMove': roomToMove,
      'diningAreaImage1': diningAreaImage1,
      'describeDiningAreaImage1': describeDiningAreaImage1,
      'diningAreaImage2': diningAreaImage2,
      'describeDiningAreaImage2': describeDiningAreaImage2,
      'chairMeasurements': chairMeasurements.map((e) => e.toJson()).toList(),
      'tableMeasurements': tableMeasurements.map((e) => e.toJson()).toList(),
      'escalatorType': escalatorType,
      'escalatorImage': escalatorImage,
      'describeEscalatorImage': describeEscalatorImage,
      'liftFeature': liftFeature,
      'liftImage': liftImage,
      'describeLiftImage': describeLiftImage,
      'stairsFeatures': stairsFeatures,
      'stairImage': stairImage,
      'describeStairsImage': describeStairsImage,
      'rampFeature': rampFeature,
      'rampImage': rampImage,
      'describeRampImage': describeRampImage,
    };
  }
}

class ChairMeasurement {
  final List<String> chairType;
  final int? height;

  ChairMeasurement({
    required this.chairType,
    this.height,
  });

  factory ChairMeasurement.fromJson(Map<String, dynamic> json) {
    return ChairMeasurement(
      chairType: List<String>.from(json['chairType']),
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chairType': chairType,
      'height': height,
    };
  }
}

class TableMeasurement {
  final List<String> tableType;
  final int height;

  TableMeasurement({
    required this.tableType,
    required this.height,
  });

  factory TableMeasurement.fromJson(Map<String, dynamic> json) {
    return TableMeasurement(
      tableType: List<String>.from(json['tableType']),
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableType': tableType,
      'height': height,
    };
  }
}