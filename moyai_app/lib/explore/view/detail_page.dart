import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/explore/model/entities/accessibility.dart';
import 'package:moyai_app/explore/model/entities/additionalInformation.dart';
import 'package:moyai_app/explore/model/entities/option_for_access.dart';
import 'package:moyai_app/explore/model/entities/toilet.dart';
import 'package:moyai_app/explore/model/entities/venue.dart';
import 'package:moyai_app/explore/model/entities/venueEnvironments.dart';
import 'package:moyai_app/explore/model/entities/venue_detail.dart';
import 'package:moyai_app/explore/view/reviews_page.dart';
import 'package:moyai_app/explore/view/toilet_info_page.dart';
import 'package:moyai_app/explore/view_model/detail_page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/themes/spacing.dart';
import '../../utils/themes/typography.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'full_screen_360.dart';

class DetailPage extends StatefulWidget {
  final String heroTag;
  final Venue venue;
  const DetailPage({super.key, required this.heroTag, required this.venue});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool isInFav = false;
  VenueDetail? venueDetail;
  late Item toilet;
  late Item accessibility;
  late final List<Item> _data;

  //BTN that controls images carousel
  final CarouselSliderController btnCarouselController = CarouselSliderController();


  final urlImages = [
    "https://images.unsplash.com/photo-1593642532973-d31b6557fa68",
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
    "https://images.unsplash.com/photo-1593642532973-d31b6557fa68",
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel =
          Provider.of<DetailPageViewModel>(context, listen: false);
      var detail =
          await viewModel.getMoreDetailOnVenue(widget.venue.venueId, context);
      bool inFav = await viewModel.checkInFav(context, widget.venue.venueId);
      setState(() {
        isInFav = inFav; // Set the value in the state after the check
        venueDetail = detail;

        print(inFav);
        print(venueDetail?.accessibility?.toJson());

        Toilet? venueToilet = venueDetail?.toilets;
        Accessibility? venueAccessibility = venueDetail?.accessibility;
        List<OptionForAccess>? optionForAccess = venueDetail?.optionForAccess;
        VenueEnvironments? venueEnvironment = venueDetail?.venueEnvironments;
        AdditionalInformation? addInfo = venueDetail?.additionalInformation;
        Item toilet = Item(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.small),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Text(
                        "Where Closest Toilet Is: ",
                        style: CustomTypography.subHead,
                      ),
                      title: Text(
                          venueToilet?.whereClosestToiletIs ?? "NO INFO",
                          style: CustomTypography.subHead),
                    ),
                    ListTile(
                      leading: const Text(
                        "Distance to Toilet: ",
                        style: CustomTypography.subHead,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: venueToilet?.distanceToToilet != null &&
                                venueToilet!.distanceToToilet!.isNotEmpty
                            ? venueToilet.distanceToToilet!.map((feature) {
                                return Text(feature.toString(),
                                    textAlign: TextAlign.start,
                                    style: CustomTypography.subHead);
                              }).toList()
                            : [
                                const Text("Distance to toilet not available.",
                                    style: CustomTypography.subHead),
                              ],
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Is Journey to Toilet Flat: ",
                        style: CustomTypography.subHead,
                      ),
                      title: Text("${venueToilet?.isJourneyToToiletFlat}",
                          style: CustomTypography.subHead),
                    ),
                    ListTile(
                      leading: const Text(
                        "Lighting: ",
                        style: CustomTypography.footNote,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: venueToilet?.toiletLighting != null &&
                                venueToilet!.toiletLighting!.isNotEmpty
                            ? venueToilet.toiletLighting!.map((feature) {
                                return Text(feature.toString(),
                                    textAlign: TextAlign.start,
                                    style: CustomTypography.subHead);
                              }).toList()
                            : [
                                const Text("No Lightning info available.",
                                    style: CustomTypography.footNote),
                              ],
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Is ramp available: ",
                        style: CustomTypography.footNote,
                      ),
                      title: venueToilet?.rampFeatures != null
                          ? const Text("Yes", style: CustomTypography.subHead)
                          : const Text("No", style: CustomTypography.subHead),
                    ),
                    ListTile(
                      leading: const Text(
                        "Is Stairs available: ",
                        style: CustomTypography.footNote,
                      ),
                      title: venueToilet?.stairsFeatures != null
                          ? const Text("Yes", style: CustomTypography.subHead)
                          : const Text("No", style: CustomTypography.subHead),
                    ),
                    ListTile(
                      leading: const Text(
                        "Is Escalator available: ",
                        style: CustomTypography.footNote,
                      ),
                      title: venueToilet?.escalatorType != null
                          ? const Text("Yes", style: CustomTypography.subHead)
                          : const Text("No", style: CustomTypography.subHead),
                    ),
                    ListTile(
                      leading: const Text(
                        "Is Rail available: ",
                        style: CustomTypography.footNote,
                      ),
                      title: venueToilet?.railLocation != null
                          ? const Text("Yes", style: CustomTypography.subHead)
                          : const Text("No", style: CustomTypography.subHead),
                    ),
                    ListTile(
                      leading: const Text(
                        "Is Lift available: ",
                        style: CustomTypography.footNote,
                      ),
                      title: venueToilet?.liftFeatures != null
                          ? const Text("Yes", style: CustomTypography.subHead)
                          : const Text("No", style: CustomTypography.subHead),
                    ),
                    CustomPrimaryButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ToiletInfoPage(toilet: venueToilet!)));
                        },
                        buttonTitle: "View More info"),
                  ],
                ),
              ),
            ),
            title: 'Toilet');
        Item accessibility = Item(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.small),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Text("Accessibility Features: ",
                        style: CustomTypography.footNote),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: venueAccessibility?.insideFeatures != null &&
                              venueAccessibility!.insideFeatures!.isNotEmpty
                          ? venueAccessibility.insideFeatures!.map((feature) {
                              return Text(feature.toString(),
                                  textAlign: TextAlign.start,
                                  style: CustomTypography.subHead);
                            }).toList()
                          : [
                              const Text("No features available.",
                                  style: CustomTypography.footNote)
                            ],
                    ),
                  ),

                  // Flooring Features
                  ExpansionTile(
                    title: const Text("Flooring:"),
                    children: venueAccessibility?.flooring != null &&
                            venueAccessibility!.flooring!.isNotEmpty
                        ? venueAccessibility.flooring!.map((feature) {
                            return Text(feature.toString(),
                                textAlign: TextAlign.start);
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("No flooring features available."))
                          ],
                  ),

                  // Room to Move
                  ExpansionTile(
                    title: const Text("Room to Move:"),
                    children: venueAccessibility?.roomToMove != null &&
                            venueAccessibility!.roomToMove!.isNotEmpty
                        ? venueAccessibility.roomToMove!.map((feature) {
                            return Text(feature.toString(),
                                textAlign: TextAlign.start);
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    "Room to move features not available."))
                          ],
                  ),

                  // Chair Measurements
                  ExpansionTile(
                    title: const Text("Chair Measurements:"),
                    children: venueAccessibility?.chairMeasurements != null &&
                            venueAccessibility!.chairMeasurements!.isNotEmpty
                        ? venueAccessibility.chairMeasurements!.map((chair) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Chair Type: ${chair.chairType.join(", ")}",
                                    style: CustomTypography.subHead),
                                if (chair.height != null)
                                  Text("Height: ${chair.height}",
                                      style: CustomTypography.subHead),
                              ],
                            );
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("No chair measurements available."))
                          ],
                  ),

                  // Table Measurements
                  ExpansionTile(
                    title: const Text("Table Measurements:"),
                    children: venueAccessibility?.tableMeasurements != null &&
                            venueAccessibility!.tableMeasurements!.isNotEmpty
                        ? venueAccessibility.tableMeasurements!.map((table) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Table Type: ${table.tableType.join(", ")}",
                                    style: CustomTypography.subHead),
                                Text("Height: ${table.height}",
                                    style: CustomTypography.subHead),
                              ],
                            );
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("No table measurements available."))
                          ],
                  ),

                  // Escalator
                  ExpansionTile(
                    title: const Text("Escalator Type:"),
                    children: venueAccessibility?.escalatorType != null &&
                            venueAccessibility!.escalatorType!.isNotEmpty
                        ? venueAccessibility.escalatorType!.map((type) {
                            return Text(type.toString(),
                                textAlign: TextAlign.start);
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Escalator type not available."))
                          ],
                  ),

                  // Lift Features
                  ExpansionTile(
                    title: const Text("Lift Features:"),
                    children: venueAccessibility?.liftFeature != null &&
                            venueAccessibility!.liftFeature!.isNotEmpty
                        ? venueAccessibility.liftFeature!.map((feature) {
                            return Text(feature.toString(),
                                textAlign: TextAlign.start);
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Lift features not available."))
                          ],
                  ),

                  // Stairs Features
                  ExpansionTile(
                    title: const Text("Stairs Features:"),
                    children: venueAccessibility?.stairsFeatures != null &&
                            venueAccessibility!.stairsFeatures!.isNotEmpty
                        ? venueAccessibility.stairsFeatures!.map((feature) {
                            return Text(feature.toString(),
                                textAlign: TextAlign.start);
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Stairs features not available."))
                          ],
                  ),

                  // Ramp Features
                  ExpansionTile(
                    title: const Text("Ramp Features:"),
                    children: venueAccessibility?.rampFeature != null &&
                            venueAccessibility!.rampFeature!.isNotEmpty
                        ? venueAccessibility.rampFeature!.map((feature) {
                            return Text(feature.toString(),
                                textAlign: TextAlign.start);
                          }).toList()
                        : [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Ramp features not available."))
                          ],
                  ),

                  // Images and Descriptions for various features
                  if (venueAccessibility?.escalatorImage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                              venueAccessibility?.escalatorImage ?? ''),
                          Text(venueAccessibility?.describeEscalatorImage ??
                              'No description available.'),
                        ],
                      ),
                    ),

                  // Repeat similar structure for other optional fields like liftImage, rampImage, etc.
                ],
              ),
            ),
          ),
          title: 'Accessibility Features',
        );
        // environment item here similar to toilet and accessibility mapping them dynamically
        Item environment = Item(
            title: "Environment",
            child: Column(
              children: [
                ListTile(
                  leading: const Text(
                    "Animals Welcome: ",
                    style: CustomTypography.footNote,
                  ),
                  title: Text("${venueEnvironment?.animalsWelcome}",
                      style: CustomTypography.subHead),
                ),
                ListTile(
                  leading: const Text(
                    "Flooring: ",
                    style: CustomTypography.footNote,
                  ),
                  title: Text("${venueEnvironment?.flooring}",
                      style: CustomTypography.subHead),
                ),
                ListTile(
                  leading: const Text(
                    "Average Decibel Reading: ",
                    style: CustomTypography.footNote,
                  ),
                  title: Text("${venueEnvironment?.avgDecibelReading}",
                      style: CustomTypography.subHead),
                ),
                ListTile(
                  leading: const Text(
                    "Max Decibel Reading: ",
                    style: CustomTypography.footNote,
                  ),
                  title: Text("${venueEnvironment?.maxDecibelReading}",
                      style: CustomTypography.subHead),
                ),
                ListTile(
                  leading: const Text(
                    "Time of  Reading: ",
                    style: CustomTypography.footNote,
                  ),
                  title: Text("${venueEnvironment?.timeOfReading}",
                      style: CustomTypography.subHead),
                ),
                ExpansionTile(
                  title: const Text("Venue Lightning:"),
                  children: venueEnvironment?.venueLightning != null &&
                          venueEnvironment!.venueLightning.isNotEmpty
                      ? venueEnvironment.venueLightning.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No lightning Info"))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Visual Accessibility:"),
                  children: venueEnvironment?.visualAccessibility != null &&
                          venueEnvironment!.visualAccessibility.isNotEmpty
                      ? venueEnvironment.visualAccessibility.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No Accessibility Info"))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Sound Characteristics:"),
                  children: venueEnvironment?.soundCharacteristics != null &&
                          venueEnvironment!.soundCharacteristics.isNotEmpty
                      ? venueEnvironment.soundCharacteristics.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                              ListTile(
                                leading: const Text(
                                  "Other Sounds: ",
                                  style: CustomTypography.footNote,
                                ),
                                title: Text(venueEnvironment.timeOfReading,
                                    style: CustomTypography.subHead),
                              ),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                                  Text("No Sound Characteristics available."))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Hearing Accessibility:"),
                  children: venueEnvironment?.hearingAccessibility != null &&
                          venueEnvironment!.hearingAccessibility.isNotEmpty
                      ? venueEnvironment.hearingAccessibility.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "No Hearing Accessibility info available."))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Smell:"),
                  children: venueEnvironment?.smell != null &&
                          venueEnvironment!.smell.isNotEmpty
                      ? venueEnvironment.smell.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No Smell info available."))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Temperature:"),
                  children: venueEnvironment?.temperature != null &&
                          venueEnvironment!.temperature.isNotEmpty
                      ? venueEnvironment.temperature.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No Temperature info available."))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Visual Stimulation:"),
                  children: venueEnvironment?.visualStimulation != null &&
                          venueEnvironment!.visualStimulation.isNotEmpty
                      ? venueEnvironment.visualStimulation.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                                  Text("No Visual Stimulation info available."))
                        ],
                ),
                ExpansionTile(
                  title: const Text("Overwhelm Management"),
                  children: venueEnvironment?.overwhelmManagement != null &&
                          venueEnvironment!.overwhelmManagement.isNotEmpty
                      ? venueEnvironment.overwhelmManagement.map((env) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(env.toString(),
                                  style: CustomTypography.subHead),
                            ],
                          );
                        }).toList()
                      : [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "No Overwhelm Management info available."))
                        ],
                ),
              ],
            ));

        List<Item> generateItems() {
          return [toilet, accessibility, environment];
        }

        _data = generateItems();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var venue = widget.venue;
    return Consumer<DetailPageViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (
                  BuildContext context,
                ) {
                  return SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.large),
                      child: Column(
                        children: [
                          CustomPrimaryButton(
                              onPressed: () async {
                                await viewModel.addVenueToFavorite(
                                    venue.venueId, context);
                                if (isInFav) {
                                  // Call method to remove the venue from favorites
                                  await viewModel.removeFromFavourites(
                                      venue.venueId, context);
                                } else {
                                  // Call method to add the venue to favorites
                                  await viewModel.addVenueToFavorite(
                                      venue.venueId, context);
                                }
                              },
                              buttonTitle: isInFav
                                  ? "Remove from favourites"
                                  : "Add to Favourites"),
                          const SizedBox(
                            height: Spacing.xSmall,
                          ),
                          CustomPrimaryButton(
                              onPressed: () {},
                              buttonTitle: "Check In/ Verify"),
                          const SizedBox(
                            height: Spacing.xSmall,
                          ),
                          CustomPrimaryButton(
                              onPressed: () {},
                              buttonTitle: "Chat with Community"),
                          const SizedBox(
                            height: Spacing.xSmall,
                          ),
                          CustomPrimaryButton(
                              onPressed: () {},
                              buttonTitle: "Feedback to Business"),
                        ],
                      ),
                    ),
                  );
                }),
            shape: const CircleBorder(),
            child: const Icon(Icons.message),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 420,
                  /*flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0),
                    title: Text(
                      venue.businessName,
                      style: CustomTypography.title2,
                    ),
                    background: Column(
                      children: [
                        Hero(
                          tag: widget.heroTag,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Image.network(
                                  venue.frontImage != null
                                      ? venue.frontImage!
                                      : "https://images.unsplash.com/photo-1727707185480-a50e6090b58c?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipOval(
                                            child: Image.network(
                                          'https://images.unsplash.com/photo-1727463507451-366dd3c3b7f9?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw3OHx8fGVufDB8fHx8fA%3D%3D',
                                          fit: BoxFit.fitWidth,
                                        ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.small,
                                    vertical: Spacing.x2Small),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade400,
                                          borderRadius: BorderRadius.circular(
                                              Spacing.x2Small)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Spacing.xSmall,
                                            vertical: Spacing.x2Small),
                                        child: Text(
                                          "99",
                                          style: CustomTypography.title1
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),*/
                  flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constrains){
                        double collapseRatio = (constrains.maxHeight - kToolbarHeight) / (250.0 - kToolbarHeight);
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: EdgeInsetsDirectional.only(
                            start: collapseRatio > 0.5 ? 16.0 : 0.0, // Left padding when expanded
                            bottom: 16.0, // Padding from the bottom
                          ),
                          title: Align(
                            alignment: collapseRatio > 0.5
                                ?AlignmentDirectional.bottomStart // Left-aligned when expanded
                                : AlignmentDirectional.bottomCenter,
                            child: Text(
                              venue.businessName,
                              style: CustomTypography.title2,),// Centered when collapsed
                          ),
                          background: Column(
                            children: [
                              Hero(
                                tag: widget.heroTag,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 30),
                                      child: Image.network(
                                        venue.frontImage != null
                                            ? venue.frontImage!
                                            : "https://images.unsplash.com/photo-1727707185480-a50e6090b58c?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: ClipOval(
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1727463507451-366dd3c3b7f9?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw3OHx8fGVufDB8fHx8fA%3D%3D',
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                              ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    // Perform the action
                                                  },
                                                  icon: Icon(Icons.favorite, size: Spacing.x2Large, color: Colors.red.shade400,),
                                                  tooltip: "Like",
                                                ),

                                                const Spacer(),

                                                IconButton(
                                                  onPressed: () {
                                                    // Perform the action
                                                  },
                                                  icon: Icon(Icons.check_circle, size: Spacing.x2Large,color: Colors.green.shade400,),
                                                  tooltip: "Check-In",
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: Spacing.large,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Spacing.small,
                                            vertical: Spacing.x2Small),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.green.shade400,
                                                  borderRadius: BorderRadius.circular(
                                                      Spacing.x2Small)),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: Spacing.xSmall,
                                                    vertical: Spacing.x2Small),
                                                child: Text(
                                                  "99",
                                                  style: CustomTypography.title1
                                                      .copyWith(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // image

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name of the business

                          // location of the business
                          CustomListTile(
                              title: venue.address
                                  .where((address) => address.isNotEmpty)
                                  .join(", "),
                              icon: Icons.map),
                          CustomListTile(title: venue.phone, icon: Icons.phone),
                          CustomListTile(title: venue.email, icon: Icons.email),

                          // todo:: add this in backend
                          const CustomListTile(
                              title: "www.cafedelcoffee.com.au",
                              icon: Icons.web),

                          // Details of the business

                          Padding(
                            padding: const EdgeInsets.all(Spacing.medium),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Spacing.small))),
                              color: Colors.pink.shade50,
                              child: SizedBox(
                                height: 250,
                                width: double.infinity,
                                child: GoogleMap(
                                    onTap: (location) async {
                                      print("Could ");
                                      final Uri googleMapUrl = Uri.parse(
                                          'https://www.google.com/maps/search/?api=1&query=${venue.coordinates!.latitude},${venue.coordinates!.longitude}');
                                      if (await canLaunchUrl(googleMapUrl)) {
                                        await launchUrl(googleMapUrl);
                                      } else {
                                        print("Could not launch the url");
                                      }
                                    },
                                    scrollGesturesEnabled: false,
                                    zoomControlsEnabled: false,
                                    myLocationEnabled: false,
                                    zoomGesturesEnabled: false,
                                    compassEnabled: true,
                                    markers: {
                                      Marker(
                                          markerId:
                                              MarkerId(venue.businessName),
                                          position: LatLng(
                                              venue.coordinates!.latitude,
                                              venue.coordinates!.longitude))
                                    },
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            venue.coordinates!.latitude,
                                            venue.coordinates!.longitude),
                                        zoom: 13)),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(Spacing.medium),
                            child: Center(
                              child: Stack(
                                children: [
                                  CarouselSlider.builder(
                                    carouselController: btnCarouselController,
                                      itemCount: urlImages.length,
                                      itemBuilder: (contex, index, realIndex){
                                      final urlImage = urlImages[index];
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            contex,
                                          MaterialPageRoute(
                                              builder: (context)=> FullScreen360View(imageURL: urlImage),
                                          ),
                                          );
                                        },
                                        child: buildImage(urlImage, index),
                                      );
                                      },
                                      options: CarouselOptions(
                                        height: 200,
                                        autoPlay: false,
                                        enableInfiniteScroll: false,
                                        viewportFraction: 0.8
                                      ),
                                  ),
                                  Positioned(
                                    left: 10,
                                      top: 80,
                                      child: IconButton(
                                          onPressed: (){
                                            btnCarouselController.previousPage();
                                          },
                                          icon: const Icon(Icons.arrow_back_ios),
                                        color: Colors.black,
                                      ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 80,
                                    child: IconButton(
                                      onPressed: (){
                                        btnCarouselController.nextPage();
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (venueDetail != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.large,
                                  vertical: Spacing.x2Small),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Accessibility Information ",
                                      style: CustomTypography.title2),
                                  const SizedBox(
                                    height: Spacing.small,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: Spacing.x2Small),
                                    child: ExpansionPanelList(
                                      expansionCallback:
                                          (int index, bool isExpanded) {
                                        setState(() {
                                          _data[index].isExpanded = isExpanded;
                                        });
                                      },
                                      children: _data
                                          .map<ExpansionPanel>((Item item) {
                                        return ExpansionPanel(
                                          headerBuilder: (BuildContext context,
                                              bool isExpanded) {
                                            return ListTile(
                                              title: Text(item.title),
                                            );
                                          },
                                          canTapOnHeader: true,
                                          body: item.child,
                                          isExpanded: item.isExpanded,
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  const Text("Your review ",
                                      style: CustomTypography.title2),
                                  Stack(
                                      children: [
                                        Card(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left : 12.0, top : 8, bottom:  0),
                                                child: RatingBar.builder(
                                                  itemBuilder: (context, _) =>
                                                  const Icon(
                                                      color: Colors.amber,
                                                      Icons.star),
                                                  onRatingUpdate: (rating) {},
                                                  initialRating: venueDetail
                                                      ?.userReview!.stars
                                                      .toDouble() ??
                                                      0,
                                                  itemSize: 30,
                                                  allowHalfRating: false,
                                                  ignoreGestures: true,
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(
                                                    venueDetail?.userReview
                                                        ?.reviewText ??
                                                        "No Review",
                                                    style: CustomTypography.body),
                                                subtitle: Text(
                                                    venueDetail
                                                        ?.userReview?.createdAt
                                                        .toString() ??
                                                        "No Date",
                                                    style:
                                                    CustomTypography.footNote),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            top: 10, // Distance from the top
                                            right: 10,
                                            child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit) , )
                                        ),
                                      ]
                                  ),
                                ],
                              ),
                            )
                          else
                            const Center(child: CircularProgressIndicator()),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.large,
                                vertical: Spacing.x2Small),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("From Your Community ",
                                    style: CustomTypography.title2),
                                TextButton(
                                    onPressed: () async {
                                      await viewModel.getAllReviews(
                                          venue.venueId, context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ReviewsPage(
                                                  venueId: venue.venueId)));
                                    },
                                    child: const Text("View More"))
                              ],
                            ),
                          ),

                          CarouselSlider(
                            items: const [
                              CustomUserRatingView(),
                              CustomUserRatingView(),
                              CustomUserRatingView(),
                            ],
                            options: CarouselOptions(
                                // enlargeFactor: 3,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                                height: 200,
                                enableInfiniteScroll: false,
                                animateToClosest: true),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }

  Widget buildImage(String urlImage, int index) => Container (
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: Colors.grey,
    width: double.infinity,
    child: Image.network(
      urlImage,
      fit: BoxFit.cover,
    ),
  );
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.large, vertical: Spacing.x2Small),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: Spacing.medium,
          ),
          Flexible(
            child: Text(
              overflow: TextOverflow.fade,
              title,
              style: CustomTypography.headLine,
            ),
          )
        ],
      ),
    );
  }
}

class CustomUserRatingView extends StatelessWidget {
  const CustomUserRatingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
              ignoreGestures: true,
              itemSize: 30,
              glow: false,
              initialRating: 3,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber, // Color of the stars
              ),
              onRatingUpdate: (double value) {},
            ),
            Row(children: [
              const Expanded(
                flex: 5,
                child: Text(
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut. Ut enimeiusmod tempor incididunt ut. Ut enim ad minim veniam, ris nisi ut aliquip ex ea commodo consequat."),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.network(
                          "https://images.unsplash.com/photo-1727412800268-309a3c7343d7?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMDh8fHxlbnwwfHx8fHw%3D",
                          width: 100,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      "Jeff User",
                      style: CustomTypography.headLine,
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class Item {
  Item({required this.title, required this.child, this.isExpanded = false});
  Widget child;
  String title;
  bool isExpanded;
}
