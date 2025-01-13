import 'package:flutter/material.dart';
import 'package:moyai_app/auth/view_model/signup_view_model.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/components/text_field.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:provider/provider.dart';

import '../../utils/themes/spacing.dart';
import '../../utils/themes/typography.dart';

class PhoneVerificationPage extends StatelessWidget {
  const PhoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SignUpViewModel();

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
                    Text(Const.verificationText,
                      style: CustomTypography.title1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: Spacing.small,
                ),
                CustomTextField(
                  maximumText: 6,
                    autoCorrect: false,
                    textController: viewModel.phoneVerificationController,
                    keyboardType: TextInputType.number,
                    hint: Const.pinText),
                const SizedBox(height: Spacing.small),

                const Row(
                  children: [
                    Text(Const.sentToPhoneText, style: CustomTypography.subHead,),
                  ],
                ),
                Row(
                  children: [
                    const Text(Const.notReceivedText, style: CustomTypography.subHead,),
                    TextButton(child: const Text(Const.resendText), onPressed: () {


                    },),
                  ],
                ),


                CustomPrimaryButton(
                    onPressed: () {
                      viewModel.registerAsNewUser(context);
                    }, buttonTitle: Const.registerText),
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
