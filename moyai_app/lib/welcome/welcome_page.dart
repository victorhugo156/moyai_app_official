
import 'package:flutter/material.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/navigation/routes_const.dart';
import 'package:moyai_app/utils/themes/color_pallet.dart';
import 'package:moyai_app/utils/themes/spacing.dart';
import 'package:panorama_viewer/panorama_viewer.dart';



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PanoramaViewer(
            child: Image.asset('lib/assets/images/360_img.jpg', width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,fit: BoxFit.cover, scale: 10,),
          ),

          SafeArea(child: Padding(
            padding: const EdgeInsets.all(Spacing.large),
            child: Column(
              children: [
                const Spacer(),
                CustomPrimaryButton(onPressed: () {
                  Navigator.pushNamed(context, RoutesConst.login);
                }, buttonTitle: "Login"),
                const SizedBox(height: Spacing.x2Small,),
                CustomPrimaryButton(onPressed: (){}, buttonTitle: "Continue as Guest", buttonColor: ColorPalette.gray1,)
              ],
            ),
          ))


        ],
      ),


    );
  }

}