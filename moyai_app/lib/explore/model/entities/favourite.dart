
import 'venue.dart';

class Favorite {
  final String venueId;
  final Venue venue;

  Favorite({
    required this.venueId,
    required this.venue,
  });

  // Factory method to create a Favorite instance from JSON
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      venueId: json['venueId'],
      venue: Venue.fromJson(json['venue']),
    );
  }

  // Method to convert a Favorite instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'venue': venue.toJson(),
    };
  }
}