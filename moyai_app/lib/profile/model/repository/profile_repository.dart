
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyai_app/profile/model/User.dart';
import 'package:moyai_app/utils/api_error_response.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:moyai_app/utils/const/db_const.dart';
import 'package:http/http.dart' as http;
import 'package:moyai_app/utils/const/utils_repository.dart';

import '../../../auth/model/auth_repository.dart';


class ProfileRepository {
  final storage = const FlutterSecureStorage();


  Future<dynamic> getCurrentUserProfile () async {
    var baseUrl = DbCont.baseUrl;
    var urlString = "$baseUrl/${DbCont.user}/getCurrentUserDetail";

    try {
      final accessToken = await storage.read(key: Const.accessToken);
      // sending a get request to the server
      var response = await http.get(Uri.parse(urlString), headers: {
        'Authorization': 'Bearer $accessToken'
      });

      print(response.statusCode);
      if(response.statusCode == 200) {
        Map<String, dynamic> dataResponse = jsonDecode(response.body);
        print(dataResponse);
        final userJson = dataResponse['data'] ;
        final userProfile = User.fromJson(userJson);
        return userProfile;
      }
      else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      }

    }catch(error) {
      return ApiErrorResponse(
        message: "An unexpected error occurred. Please try again later.", statusCode: 400, success: false,
      );
    }







  }

  Future<dynamic> updateUserProfile({required String editType, required String newDetails, required String password}) async {


    var authRepository = AuthRepository();
    var baseUrl = DbCont.baseUrl;
    var urlString = "$baseUrl/${DbCont.user}/editDetail";

    try {
      final accessToken = await storage.read(key: Const.accessToken);
      // sending a post request to the server
      var res = await http.post(Uri.parse(urlString), headers: {
        'Authorization': 'Bearer $accessToken'
      }, body: {
        'editType': editType,
        'newDetail': newDetails,
        'password': password
      });

      final retriedResponse = await UtilsRepository.retryHttpRequest(res: res, func:  () async  {
        await http.post(Uri.parse(urlString), headers: {
          'Authorization': 'Bearer $accessToken'
        }, body: {
          'editType': editType,
          'newDetail': newDetails,
          'password': password
        });

      }, authRepository:  authRepository);

      print(retriedResponse.statusCode);

      if(retriedResponse.statusCode == 200) {
        return true;
      }
      else {
        final Map<String, dynamic> responseData = jsonDecode(retriedResponse.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      }

    }
    catch(error) {
      return ApiErrorResponse(
        message: "An unexpected error occurred. Please try again later.", statusCode: 400, success: false,
      );
    }


  }



}