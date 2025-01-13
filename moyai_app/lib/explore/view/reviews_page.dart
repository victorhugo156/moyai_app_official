import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/explore/view_model/detail_page_view_model.dart';
import 'package:moyai_app/utils/themes/typography.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatefulWidget {
  final String venueId;
  const ReviewsPage({super.key, required this.venueId});

  // init(BuildContext context) {
  //   Provider.of<DetailPageViewModel>(context, listen: false).getAllReviews(venueId, context);
  // }

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailPageViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Reviews"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Makes it nearly full-screen
                child: Scaffold(
                  body: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.07),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [



                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                TextButton(

                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel", style: CustomTypography.headLine),
                                ),

                               const Spacer(),
                               GestureDetector(
                                   onTap: () async {
                                     await  viewModel.addReview(context: context, venueId: widget.venueId, rating: viewModel.rating.toInt(), reviewText: viewModel.reviewTextController.text);
                                      Navigator.pop(context);
                                     },
                                   child: const Text("Submit", style: CustomTypography.headLine) )

                              ],
                            ),
                          )
                      ,

                          const SizedBox(height: 20),
                           TextField(
                             controller: viewModel.reviewTextController,
                             style: CustomTypography.body,
                             autofocus: true,
                             maxLines: 5,
                             decoration: const InputDecoration(
                               hintText: 'Type tour review here...',
                             ),
                           ),
                          const SizedBox(height: 20),


                          Text( "Rate This Venue", style: CustomTypography.body,),
                          RatingBar.builder(
                            itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) {
                              viewModel.rating = rating.toInt();
                            },

                            itemCount: 5,
                            allowHalfRating: false,
                            itemSize: 35,
                            glow: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: viewModel.reviews.isEmpty
            ? const Center(
                child: Text(
                "No Reviews Yet",
                style: CustomTypography.headLine,
              ))
            : ListView.builder(
                itemCount: viewModel.reviews.length,
                itemBuilder: (context, index) {
                  RatingBar rating = RatingBar.builder(
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                    itemCount: 5,
                    allowHalfRating: false,
                    ignoreGestures: true,
                    itemSize: 25,
                    glow: false,
                    initialRating: viewModel.reviews[index].stars.toDouble(),
                  );
                  return Column(
                    children: [
                      ListTile(
                        leading: ClipOval(
                          child: CircleAvatar(
                            radius: 25,
                            child: Image.network(
                              "https://images.unsplash.com/photo-1730114660685-fc179a2817fc?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxNHx8fGVufDB8fHx8fA%3D%3D",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rating,
                            Text(
                              viewModel.reviews[index].reviewText,
                              style: CustomTypography.body,
                            ),
                          ],
                        ),
                        title: Text(
                            "${viewModel.reviews[index].user.firstName} ${viewModel.reviews[index].user.lastName}",
                            style: CustomTypography.title3),
                      ),
                    ],
                  );
                },
              ),
      );
    });
  }
}
