import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/profile/view/perosnal_information_page.dart';
import 'package:moyai_app/profile/view/personalization_setting_page.dart';

import '../../utils/themes/spacing.dart';
import '../../utils/themes/typography.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  // variable that will hold the selected image
  File? _selectedImage;

  /// function to get the image from the gallery
  Future _getImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
      _showImageBottomSheet();
    }
  }

  void _showImageBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Upload")),
                    ],
                  ),
                ),
                if (_selectedImage != null)
                  Image(
                    height: 330,
                    image: FileImage(_selectedImage!),
                  )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jess Combe"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "profileImage",
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: GestureDetector(
                    onTap: () => _getImageFromGallery(),
                    child: ClipOval(
                      child: Image.network(
                          fit: BoxFit.cover,
                          "https://images.unsplash.com/photo-1726682577615-728e4272a60c?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzfHx8ZW58MHx8fHx8"),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDetailsTile(
                icon: Icons.person,
                label: "Personal Information",
                detail: "Edit your details",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PersonalInformationPage()));
                }),
            CustomDetailsTile(
                icon: Icons.settings,
                label: "Personalise",
                detail: "Personalize your searches",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalizationSettingPage()));
                }),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.large, vertical: Spacing.small),
              child: CustomPrimaryButton(
                  onPressed: () {}, buttonTitle: "Connect to facebook"),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDetailsTile extends StatelessWidget {
  CustomDetailsTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.detail,
      required this.onTap});

  final IconData icon;
  final String label;
  final String detail;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.large, vertical: Spacing.small),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: CustomTypography.footNote,
                      ),
                      Text(
                        detail,
                        style: CustomTypography.body,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: Spacing.small),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 10),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Divider()),
            ),
          ],
        ),
      ),
    );
  }
}
