import 'package:flutter/material.dart';
import 'package:moyai_app/utils/const/const.dart';


/// This class encapsulates all  custom typography styles used throughout the Application
///
/// **Heebo**: font has been used for larger text. All font style from the Heebo family are bold,
/// - `largeTitle`, `title1`, `title2`, `title3`, `title4`
///
/// **DM Sans** font has been used for smaller text.
/// - `headLine`, `body`, `subHead`, `footNote`
///
class CustomTypography {

  // Heebo fonts -> For larger Text
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34.0,
    fontFamily: Const.kHeeboFont,
  );

  static const TextStyle title1 = TextStyle(
    fontSize: 28.0,
    fontFamily: Const.kHeeboFont,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 22.0,
    fontFamily: Const.kHeeboFont,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 20.0,
    fontFamily: Const.kHeeboFont,
  );


  // DM Sans font -> For smaller Text
  static const TextStyle headLine = TextStyle(
    fontSize: 17.0,
    fontFamily: Const.kDmSansFont,
    fontWeight: FontWeight.bold
  );

  static const TextStyle body = TextStyle(
    fontSize: 17.0,
    fontFamily: Const.kDmSansFont,
  );

  static const TextStyle subHead = TextStyle(
    fontSize: 15.0,
    fontFamily: Const.kDmSansFont,
  );

  static const TextStyle footNote = TextStyle(
    fontSize: 13.0,
    fontFamily: Const.kDmSansFont,
  );


}