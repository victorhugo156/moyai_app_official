import 'package:flutter/material.dart';
import 'package:moyai_app/explore/model/entities/toilet.dart';
import 'package:moyai_app/explore/model/entities/venue_detail.dart';

import '../../utils/themes/typography.dart';

class ToiletInfoPage extends StatelessWidget {
  final Toilet toilet;
  const ToiletInfoPage({super.key, required this.toilet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Toilet Information"),
        ),
        body: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 300,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),

                  children: [
                    Image.network("https://images.unsplash.com/photo-1719937206491-ed673f64be1f?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    Image.network("https://images.unsplash.com/photo-1719937206665-aa2c62ad9752?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDl8fHxlbnwwfHx8fHw%3D"),
                  ],
                ),
              ),

              ListTile(
                leading: const Text(
                  "Where Closest Toilet Is: ",
                  style: CustomTypography.footNote,
                ),
                title: Text("${toilet.whereClosestToiletIs}",
                    style: CustomTypography.subHead),
              ),
              ListTile(
                leading: const Text(
                  "Distance to Toilet: ",
                  style: CustomTypography.footNote,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: toilet.distanceToToilet != null &&
                          toilet.distanceToToilet!.isNotEmpty
                      ? toilet.distanceToToilet!.map((feature) {
                          return Text(feature.toString(),
                              textAlign: TextAlign.start,
                              style: CustomTypography.subHead);
                        }).toList()
                      : [
                          const Text("Distance to toilet not available.",
                              style: CustomTypography.footNote),
                        ],
                ),
              ),
              ListTile(
                leading: const Text(
                  "Is Journey to Toilet Flat: ",
                  style: CustomTypography.footNote,
                ),
                title: Text("${toilet.isJourneyToToiletFlat}",
                    style: CustomTypography.subHead),
              ),
              ListTile(
                leading: const Text(
                  "Lighting: ",
                  style: CustomTypography.footNote,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: toilet.toiletLighting != null &&
                          toilet!.toiletLighting!.isNotEmpty
                      ? toilet.toiletLighting!.map((feature) {
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

              ExpansionTile(
                title: const Text(
                  "Ramp Features",
                ),
                children: toilet.rampFeatures != null &&
                        toilet!.rampFeatures!.isNotEmpty
                    ? toilet.rampFeatures!.map((feature) {
                        return Text(
                          feature.toString(),
                          textAlign: TextAlign.start,
                        );
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No ramp features available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Stairs Features:"),
                children: toilet.stairsFeatures != null &&
                        toilet!.stairsFeatures!.isNotEmpty
                    ? toilet.stairsFeatures!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No ramp features available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: Text("Escalator Type:"),
                children: toilet.escalatorType != null &&
                        toilet!.escalatorType!.isNotEmpty
                    ? toilet.escalatorType!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Escalator Type not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Rail Location"),
                children: toilet.railLocation != null &&
                        toilet!.railLocation!.isNotEmpty
                    ? toilet.railLocation!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Rail location not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Entry to Toilet:"),
                children: toilet.entryToToilet != null &&
                        toilet!.entryToToilet!.isNotEmpty
                    ? toilet.entryToToilet!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Entry to toilet not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: Text("Toilet Usage:"),
                children: toilet.toiletUsage != null &&
                        toilet!.toiletUsage!.isNotEmpty
                    ? toilet.toiletUsage!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Usage not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Tactile Indicators:"),
                children: toilet.tactileIndicator != null &&
                        toilet!.tactileIndicator!.isNotEmpty
                    ? toilet.tactileIndicator!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Tactile indicator not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Toilet Lightning:"),
                children: toilet.toiletLighting != null &&
                        toilet!.toiletLighting!.isNotEmpty
                    ? toilet.toiletLighting!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Lightning not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Lift Features:"),
                children: toilet.liftFeatures != null &&
                        toilet!.liftFeatures!.isNotEmpty
                    ? toilet.liftFeatures!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Lift features not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Accessibility Features:"),
                children: toilet.accessibilityFeatures != null &&
                        toilet!.accessibilityFeatures!.isNotEmpty
                    ? toilet.accessibilityFeatures!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Accessibility features not available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: const Text("Entry to Toilet:"),
                children: toilet.entryToToilet != null &&
                        toilet!.entryToToilet!.isNotEmpty
                    ? toilet.entryToToilet!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No entry available."),
                        ),
                      ],
              ),
              ExpansionTile(
                title: Text("All Heights and widths"),
                children: [
                  ListTile(
                    leading: const Text(
                      "Stall Doorway Width: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Text("${toilet.stallDoorWidth}",
                        style: CustomTypography.footNote),
                  ),
                  ListTile(
                    leading: const Text(
                      "Stall Door Toilet Clearance: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Text("${toilet.stallToiletClearanceCm}",
                        style: CustomTypography.footNote),
                  ),
                  ListTile(
                    leading: const Text(
                      "Entry Width: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Text("${toilet.entryWidth}",
                        style: CustomTypography.footNote),
                  ),
                  ListTile(
                    leading: const Text(
                      "Stall Door Width: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Text("${toilet.stallDoorWidth}",
                        style: CustomTypography.footNote),
                  ),
                  ListTile(
                    leading: const Text(
                      "Stall Toilet Clearance: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Text("${toilet.stallToiletClearanceCm}",
                        style: CustomTypography.footNote),
                  ),
                  ListTile(
                    leading: const Text(
                      "Height: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Column(
                      children: toilet.toiletHeight != null &&
                              toilet!.toiletHeight!.isNotEmpty
                          ? toilet.toiletHeight!.map((feature) {
                              return Text(feature.toString(),
                                  textAlign: TextAlign.start,
                                  style: CustomTypography.footNote);
                            }).toList()
                          : [
                              Text("Toilet height not available.",
                                  style: CustomTypography.footNote),
                            ],
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      "Basin Height: ",
                      style: CustomTypography.headLine,
                    ),
                    title: Column(
                      children: toilet.basinHeight != null &&
                              toilet!.basinHeight!.isNotEmpty
                          ? toilet.basinHeight!.map((feature) {
                              return Text(feature.toString(),
                                  textAlign: TextAlign.start,
                                  style: CustomTypography.footNote);
                            }).toList()
                          : [
                              Text("Basin height not available.",
                                  style: CustomTypography.footNote),
                            ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text("Toilet Classifications:"),
                children: toilet.toiletClassifications != null &&
                        toilet!.toiletClassifications!.isNotEmpty
                    ? toilet.toiletClassifications!.map((feature) {
                        return Text(feature.toString(),
                            textAlign: TextAlign.start);
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No entry available."),
                        ),
                      ],
              ),
            ],
          ),
        ));
  }
}
