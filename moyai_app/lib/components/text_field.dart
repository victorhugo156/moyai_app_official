import 'package:flutter/material.dart';
import 'package:moyai_app/utils/themes/color_pallet.dart';

import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.textController,
      required this.keyboardType,
      required this.hint,
      this.autoCorrect = false,
      this.isPassword = false,
      this.isEnabled = true,
      this.hintFontColor = ColorPalette.gray1,
      this.autoFocus = false,
        this.backgroundColor,
      this.maximumText = 50,
        this.tapOutsideEnabled= true

      });

  final TextEditingController textController;
  final bool autoCorrect;
  final bool isPassword;
  final TextInputType keyboardType;
  final String hint;
  final bool isEnabled;
  final Color? hintFontColor;
  final int maximumText;
  final bool autoFocus;
  final bool tapOutsideEnabled;


   Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      maxLength: maximumText,
      enabled: isEnabled,
      controller: textController,
      keyboardType: keyboardType,
      obscureText: isPassword,
      autocorrect: autoCorrect,
      style: CustomTypography.body,
      onTapOutside: (focus) {
        if(tapOutsideEnabled) {
          FocusScope.of(context).unfocus();
        }
      },

      decoration: InputDecoration(
        fillColor: backgroundColor,
        counterText: "",
        helperText: null,
        hintStyle: TextStyle(color: hintFontColor),
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.xSmall),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.xSmall),
            borderSide: const BorderSide(color: ColorPalette.grape)),
        hintText: hint,
        contentPadding: const EdgeInsets.all(Spacing.medium),
      ),
    );
  }
}
