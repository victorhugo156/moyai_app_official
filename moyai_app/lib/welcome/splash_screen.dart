import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyai_app/auth/model/auth_repository.dart';
import 'package:moyai_app/main/tab_page.dart';
import 'package:moyai_app/navigation/routes_const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final repository = AuthRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () async {
      final status = await repository.checkLoginStatus();
      if (mounted) {
        if (status) {
          Navigator.of(context).pushReplacementNamed(RoutesConst.app);
        } else {
          Navigator.of(context).pushReplacementNamed(RoutesConst.main);
        }
      }
    });
  }
      @override
      void dispose() {
        super.dispose();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: Image.asset(
              'lib/assets/logo/icon_only_logo.png',
              height: 100,
            ),
          ),
        );
      }

}

