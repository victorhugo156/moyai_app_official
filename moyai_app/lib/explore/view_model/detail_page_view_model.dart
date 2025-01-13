import 'package:flutter/material.dart';
import 'package:moyai_app/explore/model/entities/review.dart';
import 'package:moyai_app/explore/model/repository/explore_repository.dart';
import 'package:moyai_app/explore/model/entities/venue_detail.dart';
import 'package:moyai_app/utils/api_error_response.dart';
import 'package:moyai_app/utils/themes/typography.dart';

import '../model/entities/favourite.dart';

class DetailPageViewModel extends ChangeNotifier {

  static final DetailPageViewModel _instance = DetailPageViewModel._internal();

  factory DetailPageViewModel() {
    return _instance;
  }

  DetailPageViewModel._internal();


  ExploreRepository repository = ExploreRepository();
   late VenueDetail venueDetail;
  List<Favorite> favVenues = [];
  List<Review> reviews = [];
  int rating = 0;
  TextEditingController reviewTextController = TextEditingController();


  Future <VenueDetail?> getMoreDetailOnVenue(String venueId,
      BuildContext context) async {
    var response = await repository.getMoreDetailsOnVenue(venueId);
    var errorMessage = "";

    // if the response is the type of Api response error
    if (response is ApiErrorResponse) {
      errorMessage = response.message;
    }
    // is response is VenueDetail type
    else if (response is VenueDetail) {
      return response;
    }
    // any other response will be treated as an error
    else {
      errorMessage = "Something went wrong";
    }

    // By default the error message is an empty string
    // if it's not empty, that means there is an error
    // that error message will be shown as Snack bar
    if (errorMessage != "") {
      final snackBar = SnackBar(
        content: Text(errorMessage, style: CustomTypography.headLine,),
        backgroundColor: Colors.red.shade400,
        showCloseIcon: true,
        duration: const Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      errorMessage = "";
    }
    return null;
  }


  // adds the selected venue to favourites for current user
  Future <void> addVenueToFavorite(String venueId, BuildContext context) async {
    var result = await repository.addVenueToFavourite(venueId);
    if (result is ApiErrorResponse) {
      var snackBar = SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(result.message, style: CustomTypography.headLine));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (result is bool) {
      if (result) {
        var snackBar = const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Successfully added to favourites",
              style: CustomTypography.headLine,));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    Navigator.pop(context);
  }


  // removes the selected venue from the favourites list of current user
  Future <void> removeFromFavourites(String venueId, BuildContext context) async {
    var result = await repository.removeFromFavourites(venueId);

    if (result is ApiErrorResponse) {
      print("Hello world");
      var snackBar = SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(result.message, style: CustomTypography.headLine));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (result is bool) {
      if (result) {
        favVenues.removeWhere((venue) => venue.venueId == venueId);
        notifyListeners();
        var snackBar = const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Successfully Removed from favourites",
              style: CustomTypography.headLine,));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }


  // get all favourites for current user
  Future<void> getAllFavourites(BuildContext context) async {
    var result = await repository.getAllFavourites();
    if (result is List<Favorite>) {
      favVenues = result;
    } else if (result is ApiErrorResponse) {
      var snackBar = SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(result.message, style: CustomTypography.headLine));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


// check if the selected venue is in favourites
  Future<bool> checkInFav(BuildContext context,  String venueId) async {
    var result = await repository.checkInFav(venueId);
    if (result is bool) {
      return result;
    } else if (result is ApiErrorResponse) {
      var snackBar = SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(result.message, style: CustomTypography.headLine));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return false;
}

// get all reviews for the selected venue
  Future<void> getAllReviews(String venueId, BuildContext context) async {
    var result = await repository.getAllReviews(venueId);
    if (result is List<Review>) {
      reviews = result;
    } else if (result is ApiErrorResponse) {
      var snackBar = SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(result.message, style: CustomTypography.headLine));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    print(reviews.length);

    notifyListeners();
  }
  Future <void> addReview(
      {required BuildContext context, required String venueId, required  int rating, required String reviewText} ) async {
    var result = await repository.addReview( venueId: venueId, rating: rating, reviewText: reviewText);
    rating = 0;
    reviewTextController.clear();
    if (result is ApiErrorResponse) {
      var snackBar = SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(result.message, style: CustomTypography.headLine));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } else if (result is bool) {
      if (result) {
        var snackBar = const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Successfully added review",
              style: CustomTypography.headLine,));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

  notifyListeners();

}

}

