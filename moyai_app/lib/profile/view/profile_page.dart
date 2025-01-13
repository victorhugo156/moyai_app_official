
import 'package:flutter/material.dart';
import 'package:moyai_app/main/moyai_community_page.dart';
import 'package:moyai_app/profile/view/profile_detail_page.dart';
import 'package:moyai_app/profile/view_model/profile_view_model.dart';
import 'package:moyai_app/utils/themes/typography.dart';
import 'package:provider/provider.dart';

import '../../utils/themes/spacing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (_) async {
      await Provider.of<ProfileViewModel>(context, listen: false)
          .getCurrentUserDetail();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: ( context,  viewModel,  child) {

        if(viewModel.userDetail == null ) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(),));
          
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Profile"),
          ),
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Spacing.medium),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: Spacing.medium,
                                  right: Spacing.medium,
                                  top: Spacing.small,
                                  bottom: Spacing.medium),
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Spacing.small),
                                    child: Column(

                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const ProfileDetailPage()));
                                          },
                                          title: const Text(
                                            "Profile",
                                            style: CustomTypography.body,
                                          ),
                                          leading: const Icon(Icons.person),
                                        ),
                                        const Divider(),
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (
                                                    context) => const MoyaiCommunityPage()));
                                          },

                                          title: const Text(
                                              "Moyai Community"),
                                          leading: const Icon(
                                              Icons.messenger_outline),
                                        ),
                                        const Divider(),
                                        const ListTile(
                                          title: Text("Favourite List"),
                                          leading: Icon(
                                              Icons.favorite_border),
                                        ),
                                        const Divider(),
                                        const ListTile(
                                          title: Text("Search Businesses"),
                                          leading: Icon(Icons.search),
                                        ),
                                        const Divider(),
                                        const ListTile(
                                          title: Text(
                                              "Request a Business to be assessed"),
                                          leading: Icon(Icons.done_rounded),
                                        ),
                                        const Divider(),
                                        ListTile(
                                          onTap: () {
                                            viewModel.logout(context);
                                          },
                                          title: const Text(
                                              "Logout"),
                                          leading: const Icon(Icons.logout),
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 20,
                  child: Column(
                    children: [
                      Hero(
                        tag: "profileImage",
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: ClipOval(
                              child: Image.network(
                                  fit: BoxFit.cover,
                                  "https://images.unsplash.com/photo-1726682577615-728e4272a60c?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzfHx8ZW58MHx8fHx8")),
                        ),
                      ),
                      Text(
                        "${viewModel.userDetail!.firstName} ${viewModel.userDetail!.lastName}",
                        style: CustomTypography.title1,
                      ),
                      Text(
                        viewModel.userDetail!.email,
                        style: CustomTypography.headLine,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
