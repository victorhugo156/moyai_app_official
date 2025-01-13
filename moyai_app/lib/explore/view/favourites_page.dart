import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moyai_app/components/each_venue.dart';
import 'package:moyai_app/explore/view/detail_page.dart';
import 'package:moyai_app/explore/view_model/detail_page_view_model.dart';
import 'package:moyai_app/explore/view_model/explore_view_model.dart';
import 'package:moyai_app/utils/themes/spacing.dart';
import 'package:moyai_app/utils/themes/typography.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../model/entities/venue.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<DetailPageViewModel>(context, listen: false)
          .getAllFavourites(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailPageViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: const Text("Favourites"),
        ),
        body: ListView.builder(
            itemCount: viewModel.favVenues.length,
            itemBuilder: (context, index) {
               var item = viewModel.favVenues[index];


              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Slidable(


                  endActionPane: ActionPane(motion: const ScrollMotion(),
                      dragDismissible: true,
                      children: [
                    SlidableAction(onPressed: (_)  async {
                      await viewModel.removeFromFavourites(item.venueId, context);




                    },

                      backgroundColor: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(10),
                      autoClose: true,

                      icon: Icons.delete,
                      label: 'Remove',
                    )
                  ]),
                  key: Key(item.venueId),
                  direction: Axis.horizontal,
                  closeOnScroll: true,

                  child: EachFavVenue(),

                ),
              );
            }),
      );
    });
  }
}

class EachFavVenue extends StatelessWidget {
  const EachFavVenue({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            Image.network(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                "https://images.unsplash.com/photo-1522791465802-47616431a4cf?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGNvb2t8ZW58MHx8MHx8fDA%3D"),
            const SizedBox(
              width: 20,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Fav",
                  style: CustomTypography.headLine,
                ),
                Text(
                  "Burwood, Nsw",
                  style: CustomTypography.body,
                ),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Text("20"),
            ),
            const SizedBox(width: Spacing.small)
          ],
        ),
      ),
    );
  }
}
