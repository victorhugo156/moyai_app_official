import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moyai_app/auth/model/login_response.dart';
import 'package:moyai_app/utils/api_error_response.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:moyai_app/utils/const/db_const.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final storage = const FlutterSecureStorage();

  // sends login details to the server and validate it with the database
  // if the details are correct, it gives back a refresh and access token
  Future<dynamic> loginUser(String email, String password) async {
    const baseUrl = "${DbCont.baseUrl}/${DbCont.user}/login";
    print(baseUrl);
    // login request body, this will be sent to the server
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final loginResponse = ApiResponse<LoginResponseData>.fromJson(
            responseData, (data) => LoginResponseData.fromJson(data));

        // storing both response token and accessToken
        await saveToken(
            accessToken: loginResponse.data.accessToken,
            refreshToken: loginResponse.data.refreshToken);
        print(loginResponse.data.refreshToken);
        return loginResponse;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      }
    } catch (error) {
      print("Error");
    }
  }

  Future<dynamic> registerUser(String firstName, String lastName,
      String phoneNumber, String email, String password) async {
    final Map<String, dynamic> requestBody = {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'phoneNumber': phoneNumber,
      'email': email,
    };

    print(requestBody);
    const baseUrl = "${DbCont.baseUrl}/${DbCont.user}/register";
    try {
      final res = await http
          .post(Uri.parse(baseUrl), body: jsonEncode(requestBody), headers: {
        'Content-Type': 'application/json',
      });

      if (res.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        final errorResponse = ApiErrorResponse.fromJson(responseData);
        return errorResponse;
      }
    } catch (error) {
      print(error);
    }
  }

  // check if the access token is valid.
  // if the token is valid then login else ask user to login again.
  Future<bool> checkLoginStatus() async {
    try {
      // getting accessToken and refreshToken

      final accessToken = await storage.read(key: Const.accessToken);
      print(accessToken);
      if (accessToken == null) {
        throw ApiErrorResponse(
            statusCode: 401, message: "Refresh token missing", success: false);
      }

      const baseUrl = DbCont.baseUrl;
      const url = "$baseUrl/${DbCont.user}/getLoginStatus";

      // send a get request
      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': "Bearer $accessToken"});

      if (response.statusCode == 200) {
        // todo :: Make adjustment later
        // Map<String, dynamic> dataResponse = jsonDecode(response.body);
        // var accessTok = dataResponse['data']['accessToken'];
        // var refTok = dataResponse['data']['refreshToken'];
        return true;
      } else if (response.statusCode == 401) {
        return false;
      } else {
        throw Error();
      }
    } catch (error) {
      print("Something went wrong, try again later");
      return false;
    }
  }

  void logout() async {
    if (await storage.containsKey(key: Const.accessToken)) {
      await storage.delete(key: Const.accessToken);
    }

    if (await storage.containsKey(key: Const.refreshToken)) {
      await storage.delete(key: Const.refreshToken);
    }
  }

  // Get a new access and refresh token
  // this function will be used when user access token expires.
  // When a server sends a 401 error this function will be called which generates a new access and refresh token
  // and the previous request is scheduled to do again
  Future<bool> refreshToken() async {
    try {
      // getting accessToken and refreshToken
      final refreshToken = await storage.read(key: Const.refreshToken);

      if (refreshToken == null) {
        throw ApiErrorResponse(
            statusCode: 401, message: "Refresh token missing", success: false);
      }

      const baseUrl = DbCont.baseUrl;
      const url = "$baseUrl/${DbCont.user}/refreshToken";

      final body = jsonEncode({
        'refreshToken': refreshToken,

      });
      // send a post request
      var response = await http.post(Uri.parse(url), body: body, headers: {
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> dataResponse = jsonDecode(response.body);
        var accessTok = dataResponse['data']['accessToken'];
        var refTok = dataResponse['data']['refreshToken'];

        await saveToken(accessToken: accessTok, refreshToken: refTok);
        return true;
      } else if (response.statusCode == 401) {
        return false;
      } else {
        throw Error();
      }
    } catch (error) {
      print("Something went wrong, try again later");
      return false;
    }
  }

  // Check and delete existing access and refresh tokens
  // and write the new tokens
  saveToken({required String accessToken, required String refreshToken}) async {
    const storage = FlutterSecureStorage();

    try {
      // Check and delete existing access and refresh tokens
      if (await storage.containsKey(key: Const.accessToken)) {
        await storage.delete(key: Const.accessToken);
      }

      if (await storage.containsKey(key: Const.refreshToken)) {
        await storage.delete(key: Const.refreshToken);
      }

      // Write the new tokens
      await storage.write(key: Const.accessToken, value: accessToken);
      await storage.write(key: Const.refreshToken, value: refreshToken);
    } catch (error) {
      print(error);
    }
  }
}
