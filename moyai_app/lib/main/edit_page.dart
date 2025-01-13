import 'package:flutter/material.dart';
import 'package:moyai_app/components/text_field.dart';
import 'package:moyai_app/enums/perosnal_info_enum.dart';
import 'package:moyai_app/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.editType, this.detail});
  final PersonalInfoEnum editType;
  final String? detail;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController editInfoTextController = TextEditingController();
  var isNotDatePicker = true;
  @override
  void initState() {
    super.initState();

    if (widget.detail != null) {
      editInfoTextController.text = widget.detail!;
    }
    if (widget.editType == PersonalInfoEnum.dob) {
      isNotDatePicker = false;
    }
  }

  Map<PersonalInfoEnum, String> personalInfoLabel = {
    PersonalInfoEnum.fullName: "Full Name",
    PersonalInfoEnum.phone: "Phone",
    PersonalInfoEnum.dob: "DOB",
    PersonalInfoEnum.personalization: "Personalization",
    PersonalInfoEnum.profileImage: "Profile Image",
    PersonalInfoEnum.password: "Password",
  };

  Map<PersonalInfoEnum, TextInputType> personalInfoKeyboardType = {
    PersonalInfoEnum.fullName: TextInputType.name,
    PersonalInfoEnum.phone: TextInputType.phone,
    PersonalInfoEnum.dob: TextInputType.datetime,
    PersonalInfoEnum.personalization: TextInputType.text,
    PersonalInfoEnum.profileImage:
        TextInputType.none, // For image upload, no keyboard needed
    PersonalInfoEnum.password: TextInputType.visiblePassword,
  };

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        // Format the date and update the text field
        editInfoTextController.text = "${selectedDate.toLocal()}".split(' ')[0]; // YYYY-MM-DD format
      });
    }
  }
  //
  // late ScaffoldMessengerState scaffoldMessenger;
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   scaffoldMessenger = ScaffoldMessenger.of(context);
  // }
  //
  //
  // @override
  // void dispose() {
  //   scaffoldMessenger.showSnackBar(const SnackBar(
  //     content: Text("Updated Successfully"),
  //     duration: Duration(seconds: 2),
  //   ));
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: ( context, viewModel, child) {
        return Scaffold(

          appBar: AppBar(
            title: Text(personalInfoLabel[widget.editType]!),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: Spacing.x2Small,
                ),
                child: TextButton(
                    onPressed: () {

                      showGeneralDialog(context: context, pageBuilder: (context, anim1, anim2) {
                        return AlertDialog(
                          title: const Text("Enter Password"),
                          content: CustomTextField(
                            textController: viewModel.confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            hint: 'Password',
                            autoFocus: true,
                            tapOutsideEnabled: false,
                            isEnabled: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.updateUserDetail(
                                  editType: widget.editType.toString().split('.').last,
                                  newDetails: editInfoTextController.text,
                                  password: viewModel.confirmPasswordController.text,
                                  context: context
                                );
                              },
                              child: const Text("Done"),
                            )
                          ],
                        );
                      });
                    },
                    child: const Text(
                      "Done",
                      style: CustomTypography.headLine,
                    )),
              )
            ],
          ),
          body: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(Spacing.medium),
              child: GestureDetector(
                  onTap: () {
                    if (widget.editType == PersonalInfoEnum.dob) {
                      _selectDate(context);
                    }
                  },

                  child: CustomTextField(
                    textController: editInfoTextController,
                    keyboardType: personalInfoKeyboardType[widget.editType]!,
                    hint: '',
                    autoFocus: true,
                    tapOutsideEnabled: false,
                    isEnabled: isNotDatePicker,
                  )),
            ),
          ),
        );
      }
    );
  }
}
