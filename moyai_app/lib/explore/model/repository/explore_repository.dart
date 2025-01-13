import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyai_app/auth/model/auth_repository.dart';
import 'package:moyai_app/explore/model/entities/favourite.dart';
import 'package:moyai_app/explore/model/entities/review.dart';
import 'package:moyai_app/explore/model/entities/venue.dart';
import 'package:moyai_app/explore/model/entities/venue_detail.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:moyai_app/utils/const/utils_repository.dart';

import '../../../utils/api_error_response.dart';
import '../../../utils/const/db_const.dart';
import 'package:http/http.dart' as http;

class ExploreRepository {
  final storage = const FlutterSecureStorage();
  final authRepository = AuthRepository();

  // gets all venue
  Future<dynamic> getAllVenue() async {
    try {
      const baseUrl = "${DbCont.baseUrl}/${DbCont.venue}/getAllVenues";
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization':
          'Bearer ${await storage.read(key: Const.accessToken)}',
        },
      );
      // Retry the request if 401 occurs
      final retriedResponse = await UtilsRepository.retryHttpRequest(
          res: res,
          func: () async =>
              http.get(
                Uri.parse(baseUrl),
                headers: {
                  'Authorization':
                  'Bearer ${await (storage.read(key: Const.accessToken))}',
                },
              ),
          authRepository: authRepository);
      // check if the response is success
      if (retriedResponse.statusCode == 200) {
        Map<String, dynamic> dataResponse = jsonDecode(retriedResponse.body);
        int venueCount = dataResponse['data']['venueCount'];
        final venuesJson = dataResponse['data']['venues'] as List;
        List<Venue> venues =
        venuesJson.map((json) => Venue.fromJson(json)).toList();
        return [venues, venueCount];
      } else {
        throw Exception(
            "Failed to load venues. Status code: ${retriedResponse
                .statusCode}");
      }
    } catch (e) {
      return e;
    }
  }

  //  get nearby venue within user's selected location
  Future<dynamic> getNearbyVenues({double radius = 2,
    required double longitude,
    required double latitude}) async {
    try {
      final accessToken = await storage.read(key: Const.accessToken);
      final String baseUrl =
          "${DbCont.baseUrl}/${DbCont
          .venue}/getNearbyVenues?radius=$radius&longitude=$longitude&latitude=$latitude";
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Retry the request if 401 occurs
      final retriedResponse = await UtilsRepository.retryHttpRequest(
          res: res,
          func: () async =>
              http.get(
                Uri.parse(baseUrl),
                headers: {
                  'Authorization':
                  'Bearer ${await (storage.read(key: Const.accessToken))}',
                },
              ),
          authRepository: authRepository);

      // check if the response is success
      if (retriedResponse.statusCode == 200) {
        Map<String, dynamic> dataResponse = jsonDecode(retriedResponse.body);
        int venueCount = dataResponse['data']['venueCount'];
        final venuesJson = dataResponse['data']['venues'] as List;
        List<Venue> venues =
        venuesJson.map((json) => Venue.fromJson(json)).toList();
        return [venues, venueCount];
      } else {
        throw Exception(
            "Failed to load venues. Status code: ${retriedResponse
                .statusCode}");
      }
    } catch (e) {
      return e;
    }
  }

  // gets the full detail of a venue
  Future<dynamic> getMoreDetailsOnVenue(String venueId) async {
    final accessToken = await storage.read(key: Const.accessToken);
    var baseUrl = "${DbCont.baseUrl}/${DbCont.venue}/info/$venueId";
    final res = await http.get(Uri.parse(baseUrl), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    // Retry the request if 401 occurs
    final retriedResponse = await UtilsRepository.retryHttpRequest(
        res: res,
        func: () async =>
            http.get(
              Uri.parse(baseUrl),
              headers: {
                'Authorization':
                'Bearer ${await (storage.read(key: Const.accessToken))}',
              },
            ),
        authRepository: authRepository);

    if (retriedResponse.statusCode == 200) {
      Map<String, dynamic> jsonRes = jsonDecode(res.body);


      final responseData = VenueDetail.fromJson(jsonRes['data']);




      return responseData;
    } else {
      final Map<String, dynamic> responseData =
      jsonDecode(retriedResponse.body);
      final errorResponse = ApiErrorResponse.fromJson(responseData);
      return errorResponse;
    }
  }

// add venue to favourites
  addVenueToFavourite(String venueId) async {
    final accessToken = await storage.read(key: Const.accessToken);
    var baseUrl = "${DbCont.baseUrl}/${DbCont.user}/addToFavourite";
    var parsedUri =
    Uri.parse(baseUrl).replace(queryParameters: {"venueId": venueId});

    // send a post request to server
    final res = await http
        .post(parsedUri, headers: {'Authorization': 'Bearer $accessToken'});

    // Retry the request if 401 occurs
    final retriedResponse = await UtilsRepository.retryHttpRequest(
        res: res,
        func: () async =>
            http.get(
              parsedUri,
              headers: {
                'Authorization':
                'Bearer ${await (storage.read(key: Const.accessToken))}',
              },
            ),
        authRepository: authRepository);

    // if tne status is success the venue has been added to favourites
    if (retriedResponse.statusCode == 200) {
      return true;
    } else {
      try {
        final Map<String, dynamic> responseData =
        jsonDecode(retriedResponse.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      } catch (e) {
        print('Error parsing response: $e');
        return null;
      }
    }
  }

  // remove venue from favourites
  removeFromFavourites(String venueId) async {
    final accessToken = await storage.read(key: Const.accessToken);
    const baseUrl = "${DbCont.baseUrl}/${DbCont.user}/removeFavourite";
    final parsedUri =
    Uri.parse(baseUrl).replace(queryParameters: {"venueId": venueId});
    // send a post request to server
    final res = await http
        .post(parsedUri, headers: {'Authorization': 'Bearer $accessToken'});

    // Retry the request if 401 occurs
    final retriedResponse = await UtilsRepository.retryHttpRequest(
        res: res,
        func: () async =>
            await http.get(
              parsedUri,
              headers: {
                'Authorization':
                'Bearer ${await (storage.read(key: Const.accessToken))}',
              },
            ),
        authRepository: authRepository);

    // if tne status is success the venue has been added to favourites
    if (retriedResponse.statusCode == 200) {
      return true;
    } else {
      try {
        final Map<String, dynamic> responseData =
        jsonDecode(retriedResponse.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      } catch (e) {
        print('Error parsing response: $e');
        return null;
      }
    }
  }

// get all venues from favourites
  Future<dynamic> getAllFavourites() async {
    final accessToken = await storage.read(key: Const.accessToken);
    const baseUrl = "${DbCont.baseUrl}/${DbCont.user}/getAllFavourite";
    var parsedUri = Uri.parse(baseUrl);
    // send a post request to server
    final res = await http
        .get(parsedUri, headers: {'Authorization': 'Bearer $accessToken'});

    // Retry the request if 401 occurs
    final retriedResponse = await UtilsRepository.retryHttpRequest(
        res: res,
        func: () async =>
            http.get(
              parsedUri,
              headers: {
                'Authorization':
                'Bearer ${await (storage.read(key: Const.accessToken))}',
              },
            ),
        authRepository: authRepository);

    // if the status is success the venue has been added to favourites
    if (retriedResponse.statusCode == 200) {
      final Map<String, dynamic> dataResponse =
      jsonDecode(retriedResponse.body);
      List<dynamic> favList = dataResponse['data']['fav'];
      List<Favorite> favorites =
      favList.map((favJson) => Favorite.fromJson(favJson)).toList();
      print("Favourites ;;");
      print(favorites);
      return favorites;
    } else {
      try {
        final Map<String, dynamic> responseData =
        jsonDecode(retriedResponse.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      } catch (e) {
        print('Error parsing response: $e');
        return ApiErrorResponse(
          message: 'Something went wrong',
          statusCode: retriedResponse.statusCode,
          success: false,
        );
      }
    }
  }

  Future<dynamic> checkInFav(String venueId) async {
    final accessToken = await storage.read(key: Const.accessToken);
    var baseUrl = "${DbCont.baseUrl}/${DbCont.user}/checkFav";
    var parsedUri =
    Uri.parse(baseUrl).replace(queryParameters: {"venueId": venueId});
    // send a post request to server
    final res = await http
        .get(parsedUri, headers: {'Authorization': 'Bearer $accessToken'});

    // Retry the request if 401 occurs
    final retriedResponse = await UtilsRepository.retryHttpRequest(
        res: res,
        func: () async =>
            http.get(
              parsedUri,
              headers: {
                'Authorization':
                'Bearer ${await (storage.read(key: Const.accessToken))}',
              },
            ),
        authRepository: authRepository);

    // if tne status is success the venue has been added to favourites
    if (retriedResponse.statusCode == 200) {
      final Map<String, dynamic> dataResponse =
      jsonDecode(retriedResponse.body);
      bool isInFav = (dataResponse['data']['isInFav']);
      return isInFav;
    } else {
      try {
        final Map<String, dynamic> responseData =
        jsonDecode(retriedResponse.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      } catch (e) {
        print('Error parsing response: $e');
        return ApiErrorResponse(
          message: 'Something went wrong',
          statusCode: retriedResponse.statusCode,
          success: false,
        );
      }
    }
  }

  Future<dynamic> searchVenue(String query) async {
    final accessToken = await storage.read(key: Const.accessToken);
    const baseUrl = "${DbCont.baseUrl}/${DbCont.venue}/getSearchedVenues";
    final parsedUri = Uri.parse(baseUrl).replace(
        queryParameters: {"keyword": query});

    var res = await http.get(parsedUri, headers: {
      'Authorization': "Bearer $accessToken"
    });


    final retriedResponse = await UtilsRepository.retryHttpRequest(
        res: res,
        func: () async =>
            http.get(
              parsedUri,
              headers: {
                'Authorization':
                'Bearer ${await (storage.read(key: Const.accessToken))}',
              },
            ),
        authRepository: authRepository);

    if (retriedResponse.statusCode == 200) {
      Map<String, dynamic> jsonRes = jsonDecode(retriedResponse.body);
      final venuesJson = jsonRes['data'] as List;
      List<Venue> venues = venuesJson.map((json) => Venue.fromJson(json))
          .toList();
      return venues;
    }
    else {
      final Map<String, dynamic> responseData = jsonDecode(
          retriedResponse.body);
      final errorResponse = ApiErrorResponse.fromJson(responseData);
      return errorResponse;
    }
  }


  Future <dynamic> getAllReviews (String venueId) async {
    try {

      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: Const.accessToken);
      const baseUrl = "${DbCont.baseUrl}/${DbCont.venue}/getReviews";
      Uri parsedUri = Uri.parse(baseUrl).replace(queryParameters: {"venueId": venueId});
      final res = await http.get(
        parsedUri,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Retry the request if 401 occurs
      final retriedResponse = await UtilsRepository.retryHttpRequest(
          res: res,
          func: () async =>
              http.get(
                parsedUri,
                headers: {
                  'Authorization':
                  'Bearer ${await (storage.read(key: Const.accessToken))}',
                },
              ),
          authRepository: AuthRepository());

      print(retriedResponse.statusCode);
      if (retriedResponse.statusCode == 200) {
        final Map<String, dynamic> dataResponse = jsonDecode(retriedResponse.body);
        final reviewsJson = dataResponse['data']['reviews'] as List;
        print(reviewsJson);

        List<Review> reviews = reviewsJson.map((json) => Review.fromJson(json)).toList();
        print(reviews);

        return reviews;
      } else {
        throw Exception("Failed to load reviews. Status code: ${retriedResponse.statusCode}");
      }
    } catch (e) {
      return e;
    }
  }


  Future <dynamic> addReview ({required String venueId, required int rating, required String reviewText}) async {
    try {
      final accessToken = await storage.read(key: Const.accessToken);
      const baseUrl = "${DbCont.baseUrl}/${DbCont.venue}/postReview";
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "venueId": venueId,
          "rating": rating,
          "reviewText": reviewText
        }),
      );

      // Retry the request if 401 occurs
      final retriedResponse = await UtilsRepository.retryHttpRequest(
          res: res,
          func: () async =>
              http.post(
                Uri.parse(baseUrl),
                headers: {
                  'Authorization':
                  'Bearer ${await (storage.read(key: Const.accessToken))}',
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  "venueId": venueId,
                  "rating": rating,
                  "ratingText": reviewText
                }),
              ),
          authRepository: AuthRepository());

      if (retriedResponse.statusCode == 201) {
        return true;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(retriedResponse.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      }
    } catch (e) {
      return e;
    }
  }

}


