import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../explore/model/entities/venue.dart';
import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class EachVenue extends StatelessWidget {
  final Venue venue;
  const EachVenue({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.pink.shade50,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Spacing.large))),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.network(
              venue.frontImage != null
            ? venue.frontImage!
                : "https://images.unsplash.com/photo-1727707185480-a50e6090b58c?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
                  child: Text(
                    venue.businessName,
                    style: CustomTypography.title3,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Spacing.medium),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "lib/assets/icons/Abmi.svg",
                          width: 20,
                        ),
                        const SizedBox(
                          width: Spacing.small,
                        ),
                        SvgPicture.asset(
                          "lib/assets/icons/accessibility.svg",
                          width: 20,
                        ),
                        const SizedBox(
                          width: Spacing.small,
                        ),
                        SvgPicture.asset(
                          "lib/assets/icons/Intol.svg",
                          width: 20,
                        ),
                        const SizedBox(
                          width: Spacing.small,
                        ),
                        SvgPicture.asset(
                          "lib/assets/icons/Map.svg",
                          width: 20,
                        ),
                        const SizedBox(
                          width: Spacing.small,
                        ),
                        SvgPicture.asset(
                          "lib/assets/icons/online.svg",
                          width: 20,
                        ),
                        const SizedBox(
                          width: Spacing.small,
                        ),
                        SvgPicture.asset(
                          "lib/assets/icons/pets.svg",
                          width: 20,
                        ),
                        const SizedBox(
                          width: Spacing.small,
                        ),
                        SvgPicture.asset(
                          "lib/assets/icons/toilets.svg",
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.small),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.small),
                        child: Image.asset(
                          "lib/assets/logo/icon_only_logo.png",
                          height: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,

                      ),
                      Text("20", style: CustomTypography.title2,)


                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
