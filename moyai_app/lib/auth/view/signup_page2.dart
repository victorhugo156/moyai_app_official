import 'package:flutter/material.dart';
import 'package:moyai_app/auth/view_model/signup_view_model.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/components/text_field.dart';
import 'package:moyai_app/navigation/routes_const.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:provider/provider.dart';

import '../../utils/themes/spacing.dart';
import '../../utils/themes/typography.dart';

class SignUpPageContinue extends StatelessWidget {
   SignUpPageContinue({super.key});
  final viewModel = SignUpViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.large),
          child:
              Consumer<SignUpViewModel>(builder: (context, viewModel, child) {
            return Column(
              children: [
                const Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Text(
                      Const.phoneNumberText,
                      style: CustomTypography.title1,
                    ),
                  ],
                ),

                const SizedBox(height: Spacing.small,),

                CustomTextField(
                    textController: viewModel.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    hint: "Phone"),
                const SizedBox(height: Spacing.small),

                CustomPrimaryButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesConst.signUp3);
                    },
                    buttonTitle: Const.continueButtonText),

                const Spacer(),

                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(Const.backToLoginButtonText))
              ],
            );
          }),
        ),
      ),
    );
  }
}
