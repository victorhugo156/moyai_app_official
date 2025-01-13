import 'package:flutter/material.dart';
import 'package:moyai_app/enums/perosnal_info_enum.dart';
import 'package:moyai_app/main/edit_page.dart';
import 'package:moyai_app/profile/view/profile_detail_page.dart';
import 'package:moyai_app/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
     builder: (BuildContext context, ProfileViewModel viewModel, Widget? child) {
       {
         return Scaffold(
           appBar: AppBar(
             title: const Text("Personal Information"),
           ),
           body: Column(
             children: [
               CustomDetailsTile(
                   icon: Icons.account_circle_outlined,
                   label: "Full Name",
                   detail:"${viewModel.userDetail?.firstName} ${viewModel.userDetail?.lastName}",
                   onTap: () {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>
                              EditPage(
                               editType: PersonalInfoEnum.fullName,
                               detail:"${viewModel.userDetail?.firstName} ${viewModel.userDetail?.lastName}",
                             )));
                   }),

               CustomDetailsTile(
                 icon: Icons.phone,
                 label: "Phone",
                 onTap: () {
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) =>
                            EditPage(
                             editType: PersonalInfoEnum.phone,
                             detail: viewModel.userDetail?.phoneNumber,
                           )));
                 },
                 detail: viewModel.userDetail!.phoneNumber,
               ),
               CustomDetailsTile(
                   icon: Icons.calendar_month,
                   label: "DOB",
                   detail: viewModel.userDetail?.dob ?? "Not set",
                   onTap: () {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>
                             EditPage(
                                 editType: PersonalInfoEnum.dob,
                                 detail: viewModel.userDetail?.dob)));
                   }),

               CustomDetailsTile(
                   icon: Icons.lock,
                   label: "Password",
                   detail: "Change your password",
                   onTap: () {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>
                             const EditPage(
                                 editType: PersonalInfoEnum.password)));
                   }),
             ],
           ),
         );
       }
     });
  }
}
