import 'package:flutter/material.dart';
import 'package:moyai_app/utils/themes/spacing.dart';

import '../../utils/themes/typography.dart';

class PersonalizationSettingPage extends StatefulWidget {
  const PersonalizationSettingPage({super.key});

  @override
  State<PersonalizationSettingPage> createState() =>
      _PersonalizationSettingPageState();
}



class _PersonalizationSettingPageState
    extends State<PersonalizationSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personalize"),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.only(right: Spacing.small),
                child: Text("Save"),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
          child: Column(
            children: [
              CustomCheckBox(
                isYesChecked: true,
                questionText:
                    "Do you use a mobility aid or find walking challenging?",
              ),
              CustomCheckBox(
                isYesChecked: true,
                questionText:
                    "Do you become overwhelmed if there is to much noise, bright or flashing lights?",
              ),
              CustomCheckBox(
                isYesChecked: true,
                questionText: "Do you have an invisible disability?",
              ),
              CustomCheckBox(
                isYesChecked: true,
                questionText: "Do you have food intolerance?",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox(
      {super.key, this.isYesChecked = false, required this.questionText});
  bool isYesChecked;
  String questionText;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xSmall),
      child: Card(
        color: Colors.pink[100],
        child: Padding(
          padding: const EdgeInsets.only(
              left: Spacing.large,
              right: Spacing.large,
              top: Spacing.medium,
              bottom: Spacing.x2Small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.questionText,
                style: CustomTypography.body,
              ),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: widget.isYesChecked,
                          onChanged: (change) {
                            setState(() {
                              widget.isYesChecked = change!;
                            });
                          }),
                      const Text("Yes")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: !widget.isYesChecked,
                          onChanged: (change) {
                            setState(() {
                              widget.isYesChecked = !change!;
                            });
                          }),
                      const Text("No")
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
