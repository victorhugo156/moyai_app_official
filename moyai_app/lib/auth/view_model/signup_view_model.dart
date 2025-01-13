import 'package:flutter/material.dart';
import 'package:moyai_app/auth/model/auth_repository.dart';
import 'package:moyai_app/navigation/routes_const.dart';
import 'package:moyai_app/utils/api_error_response.dart';
import 'package:moyai_app/utils/themes/typography.dart';

import '../../main/questions_page.dart';

class SignUpViewModel extends ChangeNotifier {

  static final SignUpViewModel _instance = SignUpViewModel._internal();

  factory SignUpViewModel() {
    return _instance;
  }
  SignUpViewModel._internal();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailContainer = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneVerificationController = TextEditingController();
  bool termsAndConditionCheckBox = false;
  DateTime dateOfBirth = DateTime(2003);

   AuthRepository repository = AuthRepository();

  // function to signup the user
  void continueSignUp(BuildContext context) {
    Navigator.pushNamed(context, RoutesConst.signUp2);
  }


  void registerAsNewUser (BuildContext context) async{

    print(firstNameController.text,);
    print(lastNameController.text,);
    print(passwordController.text,);
    print(emailContainer.text,);
    print(phoneNumberController.text,);
    var res = await repository.registerUser(firstNameController.text, lastNameController.text, phoneNumberController.text, emailContainer.text, passwordController.text);


    if (res == true) {
      print("successfully registered");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const QuestionPage()));

    }
    else if(res is ApiErrorResponse) {
      final snackBar = SnackBar(content:  Text(res.message, style: CustomTypography.headLine, ),
        backgroundColor: Colors.red.shade400,
        showCloseIcon: true,
        duration: const Duration(seconds: 4),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
}

}
