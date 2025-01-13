import 'package:flutter/material.dart';
import 'package:moyai_app/auth/model/auth_repository.dart';
import 'package:moyai_app/navigation/routes_const.dart';
import 'package:moyai_app/profile/model/User.dart';
import 'package:moyai_app/profile/model/repository/profile_repository.dart';
import 'package:moyai_app/utils/api_error_response.dart';

import '../../utils/themes/typography.dart';

class ProfileViewModel extends ChangeNotifier {

  late User? userDetail = null ;


  ProfileRepository repository = ProfileRepository();
  TextEditingController confirmPasswordController = TextEditingController();

  // gets the user details of current user.
  Future<void>getCurrentUserDetail () async{
    var res =  await repository.getCurrentUserProfile();

    if(res is User) {
      print(res);
      userDetail = res;
    } else if(res is ApiErrorResponse) {
      print(res.message);
    }

    notifyListeners();
  }

  // logs out current user
   // removes both access and refresh token from shared preferences

  void logout(BuildContext context) {
    final authRepository = AuthRepository();
    authRepository.logout();
    Navigator.pushReplacementNamed(context, RoutesConst.main);
  }

  // updates the user details of current user
  Future<void> updateUserDetail(
      {required String editType, required String newDetails, required String password, required BuildContext context}) async {
    var res = await repository.updateUserProfile(editType : editType,  newDetails : newDetails,  password: password);
    if(res is bool && res == true) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        backgroundColor: Colors.green.shade400,
        content: const Text("Updated Successfully", style: CustomTypography.subHead ),
        duration: Duration(seconds: 2),
      ));

    } else if(res is ApiErrorResponse) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade400,
        content: Text(res.message,style: CustomTypography.subHead),
        duration: const Duration(seconds: 2),
      ));
    }
    Navigator.pop(context);
    notifyListeners();
  }



}