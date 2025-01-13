import 'package:flutter/material.dart';

import '../utils/themes/color_pallet.dart';
import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    required this.onPressed,
    required this.buttonTitle,
    this.buttonColor = ColorPalette.primary
  });

  final void Function()? onPressed;
  final String buttonTitle;
  final Color? buttonColor ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Spacing.x2Large, // Set the desired width here
      child: FilledButton(

        onPressed: () => onPressed!(),
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(CustomTypography.headLine),
          backgroundColor: WidgetStateProperty.all(buttonColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.xSmall), // Set your desired radius here
            ),
          ),
        ),
        child: Text(buttonTitle),
      ),
    );
  }
}


class CustomSecondaryButton extends StatelessWidget {
  const CustomSecondaryButton({
    super.key,
    required this.onPressed,
    required this.buttonTitle,
    this.typography = CustomTypography.headLine
  });

  final void Function()? onPressed;
  final String buttonTitle;
  final TextStyle typography;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed!(),
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(typography),
        ),
      child: Text(buttonTitle),
    );
  }
}

