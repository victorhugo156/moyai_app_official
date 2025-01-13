import 'package:flutter/material.dart';
import 'package:moyai_app/explore/model/entities/venue.dart';
import 'package:moyai_app/utils/api_error_response.dart';

import '../model/repository/explore_repository.dart';

class ExploreViewModel extends ChangeNotifier {
  ExploreRepository repository = ExploreRepository();
  List<Venue> venues = [];
  List<Venue> markedInMap = [];
  List<Venue> searchedVenue = [];
  int venueCount = 0;

  final List<String> options = [
    '2km',
    '5km',
    '10km',
    '20km',
    '50km',
    "View All"
  ];
  String? selectedItem = '2km'; // Initial value

  Future<void> updateSelectedItem( BuildContext context, String? newValue) async {
      venues = [];
      selectedItem = newValue;
      if (selectedItem == "View All") {
        await getAllVenues(context);
      } else {
        var radius = selectedItem?.substring(0, selectedItem!.length - 2);
        await getNearbyVenues(
            latitude: -33.88834,
            longitude: 151.12274,
            radius: double.parse(radius!));
      }
      notifyListeners();
    }


  Future<void> getAllVenues( BuildContext context) async {

    // the returned value here is a list of venues and venue count.
    // index 0 : [venue]
    // index 1 : venue count
    var returnedValue = await repository.getAllVenue();

    if(returnedValue is List) {
      venues = returnedValue[0];
      venueCount = returnedValue[1];
    } else if (returnedValue is ApiErrorResponse) {
      showDialog(context: context, builder: (context) {
        return Center(child: SizedBox(
            height: 30,
            child: Text(returnedValue.message)));
      });
    }
    print(venueCount);
    notifyListeners();
  }

  Future<void> getNearbyVenues(
      {required double longitude,
      required double latitude,
      double radius = 2}) async {
    var returnedValue = await repository.getNearbyVenues(
        longitude: longitude, latitude: latitude, radius: radius);
    venueCount = returnedValue[1] ;
    venues = returnedValue[0];
    markedInMap = returnedValue[0];
    print(venueCount);
  }

  Future <void> searchVenues(String query) async {
    var returnedValue = await repository.searchVenue(query);
    if(returnedValue is List<Venue>)
      {
        searchedVenue = returnedValue;
        notifyListeners();
      }


  }



}
