class Venue {
  final String venueId;
  final String name;
  final String phone;
  final String? signature;
  final String email;
  final List<String> openingHours;
  final String frontImageOfBusinessDescribe;
  final bool consentObtained;
  final String? frontImage;
  final List<String> accessibleParkingAvailable;
  final List<String> closestAccessibleParking;
  final List<String> distanceToClosestAccessibleParking;
  final String assessorName;
  final String businessName;
  final String businessType;
  final List<String> address;
  final String frontImageOfBusiness;
  final Coordinates? coordinates;
  final String createdAt;
  final String updatedAt;

  Venue({
    required this.venueId,
    required this.name,
    required this.phone,
    this.signature,
    required this.email,
    required this.openingHours,
    required this.frontImageOfBusinessDescribe,
    required this.consentObtained,
    this.frontImage,
    required this.accessibleParkingAvailable,
    required this.closestAccessibleParking,
    required this.distanceToClosestAccessibleParking,
    required this.assessorName,
    required this.businessName,
    required this.businessType,
    required this.address,
    required this.frontImageOfBusiness,
    required this.coordinates,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      venueId: json['venueId'],
      name: json['name'],
      phone: json['phone'],
      signature: json['signature'],
      email: json['email'],
      openingHours: List<String>.from(json['openingHours']),
      frontImageOfBusinessDescribe: json['frontImageOfBusinessDescribe'],
      consentObtained: json['consentObtained'],
      frontImage: json['frontImage'],
      accessibleParkingAvailable: List<String>.from(json['accessibleParkingAvailable']),
      closestAccessibleParking: List<String>.from(json['closestAccessibleParking']
          .replaceAll(RegExp(r'[{}]'), '')
          .split(',')),
      distanceToClosestAccessibleParking: List<String>.from(json['distanceToClosestAccessibleParking']
          .replaceAll(RegExp(r'[{}]'), '')
          .split(',')),
      assessorName: json['assessorName'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      address: List<String>.from(json['address']),
      frontImageOfBusiness: json['frontImageOfBusiness'],
      coordinates: Coordinates.fromJson(json['coordinates']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'name': name,
      'phone': phone,
      'signature': signature,
      'email': email,
      'openingHours': openingHours,
      'frontImageOfBusinessDescribe': frontImageOfBusinessDescribe,
      'consentObtained': consentObtained,
      'frontImage': frontImage,
      'accessibleParkingAvailable': accessibleParkingAvailable,
      'closestAccessibleParking': closestAccessibleParking,
      'distanceToClosestAccessibleParking': distanceToClosestAccessibleParking,
      'assessorName': assessorName,
      'businessName': businessName,
      'businessType': businessType,
      'address': address,
      'frontImageOfBusiness': frontImageOfBusiness,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}


class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}