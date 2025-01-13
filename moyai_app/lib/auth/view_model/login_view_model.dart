import 'package:flutter/material.dart';
import 'package:moyai_app/auth/model/auth_repository.dart';
import 'package:moyai_app/auth/model/login_response.dart';
import 'package:moyai_app/utils/api_error_response.dart';
import 'package:moyai_app/utils/themes/typography.dart';

import '../../navigation/routes_const.dart';

class AuthViewModel extends ChangeNotifier {

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  AuthRepository repository =  AuthRepository();
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  String get text => emailTextController.text;
  void signIn (BuildContext context) async{

    // todo:: check email and password before asking the server to validate it.

    var response = await repository.loginUser(emailTextController.text, passwordTextController.text);
    // if the response is ApiResponse then return this
    if (response is ApiResponse<LoginResponseData>) {
      // Navigator.pushReplacementNamed(context, RoutesConst.app);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConst.app,  // Target route name
            (route) => false, // This removes all previous routes
      );

    }
    // if the response is an ApiError then show a snack bar
    else if (response is ApiErrorResponse) {
      final snackBar = SnackBar(content:  Text(response.message, style: CustomTypography.headLine, ),
      backgroundColor: Colors.red.shade400,
      showCloseIcon: true,
        duration: const Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }


  }

  void forgotPassword () {

  }

  void signUp() {

  }

  void goToSignUpPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesConst.signUp);
  }

}