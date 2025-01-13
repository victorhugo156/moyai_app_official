import 'package:flutter/material.dart';

import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class MoyaiCommunityPage extends StatelessWidget {
  const MoyaiCommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Moyai Community"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
            child: Column(
              children: [
                SearchBar(
                  hintText: "Search",
                  onTapOutside: (tap) {
                    FocusScope.of(context).unfocus();
                  },
                  trailing: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                  ],
                  elevation: const WidgetStatePropertyAll(2),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Spacing.small))),

                ),
                const SizedBox(
                  height: Spacing.large,
                ),
                const Column(
                  children: [
                    CustomComment(
                      title: "Woolworth's ramp is a no go",
                      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, stetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      msgCount: 4,
                      imgLink: "https://images.unsplash.com/photo-1727257186617-38153f3bc067?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMnx8fGVufDB8fHx8fA%3D%3D",
                    ),
                    CustomComment(
                      title: "Woolworth's ramp is a no go",
                      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, stetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      msgCount: 4,
                      imgLink: "https://images.unsplash.com/photo-1728826843838-308b101f2a8a?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxNHx8fGVufDB8fHx8fA%3D%3D",
                    ),
                    CustomComment(
                      title: "Woolworth's ramp is a no go",
                      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, stetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      msgCount: 4,
                      imgLink: "https://images.unsplash.com/photo-1728899306938-d682b4c27bd6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxN3x8fGVufDB8fHx8fA%3D%3D",
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class CustomComment extends StatelessWidget {

  final String title;
  final String body;
  final String imgLink;
  final int msgCount ;

  const CustomComment({
    super.key,
    required this.title,
    required this.body,
    required this.imgLink,
    required this.msgCount
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.small),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.medium,
              vertical: Spacing.medium),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                child: ClipOval(

                  child: Image.network(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imgLink),

                ),
              ),
              const SizedBox(
                  width: Spacing
                      .medium), // Optional: Adds space between the text and the next widget

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CustomTypography.headLine,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      body,
                      overflow: TextOverflow
                          .ellipsis, // Makes the text overflow visible by wrapping to the next line
                      maxLines: 3, //
                      softWrap:
                      true, // You can specify the number of lines here
                      style: CustomTypography.body,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.medium),
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  msgCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ) // Optional: Adds space between the text and the next widget
            ],
          ),
        ),
      ),
    );
  }
}