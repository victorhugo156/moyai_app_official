import 'package:flutter/material.dart';
import 'package:moyai_app/auth/view_model/login_view_model.dart';
import 'package:moyai_app/utils/const/const.dart';
import 'package:moyai_app/utils/themes/spacing.dart';
import 'package:provider/provider.dart';
import '../../components/custom_button.dart';
import '../../components/text_field.dart';
import '../../utils/themes/typography.dart';

class LoginPage extends StatelessWidget {
  // Variables for email and password
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
      body: SafeArea(child:
          Consumer<AuthViewModel>(builder: (context, viewModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Hero(
                  tag: Const.logoTag,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.x2Large),
                    child: Image.asset('lib/assets/logo/full_logo.png'),
                  )),
            ),
            const SizedBox(height: Spacing.x2Small,),
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    // Email Text field
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.large),
                      child: CustomTextField(
                        textController: viewModel.emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        hint: Const.emailText,
                      ),
                    ),
                    const SizedBox(
                      height: Spacing.medium,
                    ),

                    // Password Text Field
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.large),
                      child: CustomTextField(
                        textController: viewModel.passwordTextController,
                        keyboardType: TextInputType.visiblePassword,
                        hint: Const.passwordText,
                        isPassword: true,
                      ),
                    ),

                    const SizedBox(
                      height: Spacing.medium,
                    ),

                    // Login and Register Now Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.large),
                      child: CustomPrimaryButton(
                          onPressed: () => viewModel.signIn(context),
                          buttonTitle: Const.loginButtonText),
                    ),

                    const SizedBox(height: Spacing.x2Small),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: Spacing.small),
                          child: CustomSecondaryButton(
                            onPressed: () => viewModel.forgotPassword,
                            buttonTitle: Const.forgotPasswordText,
                            typography: CustomTypography.subHead,
                          ),
                        ),
                      ],
                    ),
                    // Register as New User

                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.large),
                      child: TextButton(
                          onPressed: () => viewModel.goToSignUpPage(context),
                          child: const Text(Const.goToSignUpText)),
                    )
                  ],
                )),
          ],
        );
      }
      )
      ),
    );
  }
}
