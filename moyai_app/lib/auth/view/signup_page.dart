import 'package:flutter/material.dart';
import 'package:moyai_app/auth/view_model/signup_view_model.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/components/text_field.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:provider/provider.dart';

import '../../utils/themes/spacing.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
              mainAxisSize:
                  MainAxisSize.min, // Prevents the column from stretching
              children: [
                Expanded(
                  flex: 1,
                  child: Hero(
                      tag: Const.logoTag,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.x2Large),
                        child: Image.asset('lib/assets/logo/full_logo.png'),
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: Spacing.large),

                      // Name Text Field
                      CustomTextField(
                          textController: viewModel.firstNameController,
                          keyboardType: TextInputType.name,
                          hint: Const.firstNameText),
                      const SizedBox(height: Spacing.small),
                      CustomTextField(
                          textController: viewModel.lastNameController,
                          keyboardType: TextInputType.name,
                          hint: Const.lastNameText),
                      const SizedBox(height: Spacing.small),

                      CustomTextField(
                          textController: viewModel.emailContainer,
                          keyboardType: TextInputType.emailAddress,
                          hint: Const.emailText),

                      const SizedBox(height: Spacing.small),

                      CustomPrimaryButton(
                          onPressed: () => viewModel.continueSignUp(context),
                          buttonTitle: Const.continueButtonText),

                      const SizedBox(
                        height: Spacing.xSmall,
                      ),

                      const Spacer(),

                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(Const.backToLoginButtonText))
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
