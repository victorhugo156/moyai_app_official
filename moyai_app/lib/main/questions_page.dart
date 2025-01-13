import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:moyai_app/main/tab_page.dart';
import 'package:moyai_app/utils/themes/color_pallet.dart';

import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TabPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return OnBoardingSlider(
            addButton: true,
            controllerColor: ColorPalette.primary,
            onFinish: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const TabPage())); },
            finishButtonText: "Let's start",
              finishButtonStyle: const FinishButtonStyle(

                backgroundColor: ColorPalette.primary,
              ),
              totalPage: 4,
              headerBackgroundColor: Colors.pink.shade50,
              background: [

                Container(),
                Container(),
                Container(),
                Container(),


              ],
              speed: 1.0,
              pageBodies: [
                const Padding(
                  padding: EdgeInsets.all(Spacing.large),
                  child: Center(child: Text("Let's Learn more about you before we get started!", style: CustomTypography.largeTitle,)),
                ),
                CustomQuestionare("This is first question? "),
                CustomQuestionare("This is the second question "),
                CustomQuestionare("This is the third question "),

              ]);
        });
  }

  Padding CustomQuestionare(String question) {

    return Padding(
                padding: const EdgeInsets.all(Spacing.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(question, style: CustomTypography.title1,),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value ) { }),
                        const Text("Yes", style: CustomTypography.body,)
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value ) { }),
                        const Text("No", style: CustomTypography.body,)
                      ],
                    ),


                  ],
                ),
              );
  }
}



