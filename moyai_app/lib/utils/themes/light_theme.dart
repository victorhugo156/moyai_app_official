import 'package:flutter/material.dart';
import 'package:moyai_app/utils/themes/color_pallet.dart';

import '../const/const.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: Const.kDmSansFont,
    primaryColor: ColorPalette.primary,
    colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: ColorPalette.primary,
    onPrimary: Colors.white,
    secondary: ColorPalette.gray1,
    onSecondary: Colors.black,
    surface: Colors.white,
    error: Colors.red,
    onError: ColorPalette.grape,
    onSurface: Colors.black,
    // Note: no direct property for borders in ColorScheme
    // You can create a custom property or use a variable elsewhere
),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white));
