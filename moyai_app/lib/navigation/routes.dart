import 'package:flutter/cupertino.dart';
import 'package:moyai_app/auth/view/login_page.dart';
import 'package:moyai_app/auth/view/phone_verification_page.dart';
import 'package:moyai_app/auth/view/signUp_page3.dart';
import 'package:moyai_app/auth/view/signup_page2.dart';
import 'package:moyai_app/main/tab_page.dart';
import 'package:moyai_app/navigation/routes_const.dart';
import 'package:moyai_app/welcome/welcome_page.dart';
import '../auth/view/signup_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  RoutesConst.main : (context) => const WelcomePage() ,
  RoutesConst.login : (context) => const LoginPage(),
  RoutesConst.signUp : (context) => const SignUpPage(),
  RoutesConst.signUp2 : (context) =>  SignUpPageContinue(),
  RoutesConst.signUp3 : (context) =>  SignUpPagePassword(),
  RoutesConst.phoneVerification : (context) => const PhoneVerificationPage(),
  RoutesConst.app : (context) => const TabPage(),
};
