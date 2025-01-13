import 'package:flutter/material.dart';
import 'package:moyai_app/components/each_venue.dart';
import 'package:moyai_app/explore/view_model/explore_view_model.dart';
import 'package:moyai_app/explore/view/detail_page.dart';
import 'package:provider/provider.dart';

import '../../utils/themes/spacing.dart';
import '../../utils/themes/typography.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  
  
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback( (_) async {
      await Provider.of<ExploreViewModel>(context, listen: false)
          .updateSelectedItem(context, '2km');
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Search"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(Spacing.medium),
          child: Consumer<ExploreViewModel>(
              builder: (context, viewModel, child) {

            return Column(
              children: [
                SearchBar(
                  hintText: "Search",
                  onTapOutside: (tap) {
                    FocusScope.of(context).unfocus();
                  },
                  elevation: const WidgetStatePropertyAll(2),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Spacing.small))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "${viewModel.venueCount} Venue within",
                        style: CustomTypography.footNote,
                      ),
                      DropdownButton<String>(
                          value: viewModel.selectedItem,
                          items: viewModel.options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: CustomTypography.footNote,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            await viewModel.updateSelectedItem(context, newValue);
                            setState(() {});
                          }),
                    ],
                  ),
                ),
                if (viewModel.venueCount > 0) Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.venues.length,
                    itemBuilder: (context, index) {
                      final venue = viewModel.venues[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Spacing.x2Small),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    venue: venue,
                                    heroTag:
                                        "detailView_${venue.venueId}"),
                              ),
                            );
                          },
                          child: Hero(
                            tag: "detailView_${venue.venueId}",
                            child: EachVenue(venue: venue),
                          ),
                        ),
                      );
                    },
                  ),
                )
                else const Expanded(child: Padding(
                  padding: EdgeInsets.only( bottom: Spacing.x3Large),
                  child: Center(child : Text("No venues found", style: CustomTypography.headLine,) ),
                ))
              ],
            );
          })),
    );
  }
}
