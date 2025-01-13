import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moyai_app/auth/view_model/login_view_model.dart';
import 'package:moyai_app/auth/view_model/signup_view_model.dart';
import 'package:moyai_app/explore/view_model/explore_view_model.dart';
import 'package:moyai_app/profile/view_model/profile_view_model.dart';
import 'package:moyai_app/welcome/splash_screen.dart';
import 'package:provider/provider.dart';

import 'explore/view_model/detail_page_view_model.dart';
import 'main/tab_page.dart';
import 'navigation/routes.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ExploreViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => DetailPageViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        // theme: lightTheme,
        home: const SplashScreen(),
        routes: appRoutes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}