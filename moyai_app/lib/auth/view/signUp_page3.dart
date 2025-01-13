
import 'package:flutter/material.dart';
import 'package:moyai_app/auth/view_model/signup_view_model.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/components/text_field.dart';
import 'package:moyai_app/navigation/routes_const.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:provider/provider.dart';

import '../../utils/themes/spacing.dart';
import '../../utils/themes/typography.dart';

class SignUpPagePassword extends StatelessWidget {
   SignUpPagePassword({super.key});
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
                      "Create a Password",
                      style: CustomTypography.title1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: Spacing.small,
                ),
                CustomTextField(
                    isPassword: true,
                    autoCorrect: false,
                    textController: viewModel.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hint: Const.passwordText),
                const SizedBox(height: Spacing.small),
                CustomTextField(
                    isPassword: true,
                    autoCorrect: false,
                    textController: viewModel.confirmPasswordController,
                    keyboardType: TextInputType.name,
                    hint: Const.confirmPasswordText),

                Row(
                  children: [
                    Theme(data: Theme.of(context).copyWith(

                      visualDensity: const VisualDensity(horizontal: -4.0,), // Reduce horizontal padding
                    ), child:   Checkbox(value: viewModel.termsAndConditionCheckBox, onChanged: (value) {
                      viewModel.termsAndConditionCheckBox = value!;
                    }),),

                    const Text(Const.agreeToText),

                    TextButton(

                        clipBehavior: Clip.none,
                        onPressed: () => showBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (BuildContext context) {
                      return const Placeholder();
                    }),
                        child: const Row(
                          children: [
                            Text(Const.termsAndConditionText),
                          ],
                        )
                    )
                  ],

                ),

                CustomPrimaryButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesConst.phoneVerification);

                    }, buttonTitle: Const.continueButtonText),
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
