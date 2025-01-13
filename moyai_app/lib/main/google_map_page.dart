import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moyai_app/components/custom_button.dart';
import 'package:moyai_app/explore/view/detail_page.dart';
import 'package:moyai_app/explore/view_model/explore_view_model.dart';
import 'package:moyai_app/utils/themes/color_pallet.dart';
import 'package:provider/provider.dart';

import '../explore/model/entities/venue.dart';
import '../explore/view_model/detail_page_view_model.dart';
import '../utils/themes/spacing.dart';
import '../utils/themes/typography.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final FocusNode _focusNode = FocusNode();
  var _selectedPosition = const LatLng(0, 0);
  final CameraPosition _cameraPosition = const CameraPosition(
    target:
        LatLng(-25.2744, 133.7751), // Coordinates for the center of Australia
    zoom: 4, // Zoom level suitable for showing the whole country
  );

  GoogleMapController? mapController;
  Location location = Location();
  LatLng _currentLocation = const LatLng(0, 0);
  MapType userChosenMapType = MapType.normal;
  bool showSearchSuggestion = false;

  @override
  void initState() {
    _requestLocation();
    super.initState();
  }

  Timer? _debounce;

  void _onSearchChanged(String value, ExploreViewModel viewModel) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      viewModel.searchVenues(value);
    });
  }

  Future<void> _requestLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // Location service not enabled
      }
    }
    // Check location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // Permission not granted
      }
    }
    print("start");
    print(await location.hasPermission());
    print( await location.getLocation());
    print("end");

    if(permissionGranted == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission Denied"),
          duration: Duration(seconds: 2),
        ),
      );

    }

    try {
      // Get current location
      var userLocation = await location.getLocation().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          print("Location request timed out");
          return LocationData.fromMap({
            "latitude": 0.0,
            "longitude": 0.0,
          });
        },
      );

      if (userLocation.latitude != null && userLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(userLocation.latitude!, userLocation.longitude!);
        });
      }
      // Move camera to user's current location
      _moveToCurrentLocation();
    } catch (error) {
      print("Error getting $error");
    }
  }

  void _moveToCurrentLocation() {
    if (mapController != null && _currentLocation != const LatLng(0, 0)) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation, // The new latitude and longitude
          zoom: 15.0, // Set the desired zoom level (for example, 15)
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreViewModel>(builder: (context, viewModel, child) {
      return Stack(children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller; // Initialize mapController here
            },
            markers: {
              for (var venue in viewModel.markedInMap)
                Marker(
                  markerId: MarkerId(venue.venueId),
                  position: LatLng(venue.coordinates!.latitude,
                      venue.coordinates!.longitude),
                  infoWindow: InfoWindow(
                    title: venue.businessName,
                    snippet: venue.address.join(", "),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPosition = LatLng(venue.coordinates!.latitude,
                          venue.coordinates!.longitude);
                      showLocationModal(context, _selectedPosition, venue);
                    });
                  },
                )
            },
            initialCameraPosition: _cameraPosition,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            mapType: userChosenMapType,
          ),
        ),
        GestureDetector(
          onTap: () {
            _focusNode.unfocus();
            setState(() {
              showSearchSuggestion = false;
            });
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
              child: Column(
                children: [
                  SearchBar(
                    focusNode: _focusNode,
                    trailing: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.search))
                    ],
                    onSubmitted: (value) {
                      _onSearchChanged(value, viewModel);
                    },
                    hintText: "Search",
                    onChanged: (value) {
                      if (value == "") {
                        setState(() {
                          showSearchSuggestion = false;
                        });
                      } else {
                        setState(() {
                          showSearchSuggestion = true;
                        });
                      }

                      _onSearchChanged(value, viewModel);
                    },
                    onTapOutside: (tap) {
                      FocusScope.of(context).unfocus();
                    },
                    elevation: const WidgetStatePropertyAll(2),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Spacing.small))),
                  ),
                  const SizedBox(
                    height: Spacing.x2Small,
                  ),
                  if (viewModel.searchedVenue.isNotEmpty &&
                      showSearchSuggestion)
                    Positioned(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: viewModel.searchedVenue.length > 4
                                  ? 300 // Limit height for scrolling if more than 4 items
                                  : double.infinity,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: viewModel.searchedVenue.length,
                              itemBuilder: (context, index) {
                                final venue = viewModel.searchedVenue[index];
                                return GestureDetector(
                                  onTap: () {
                                    _selectedPosition = LatLng(
                                        venue.coordinates!.latitude,
                                        venue.coordinates!.longitude);

                                    setState(() {
                                      viewModel.markedInMap = [];
                                      viewModel.markedInMap
                                          .add(viewModel.searchedVenue[index]);
                                      mapController!.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target:
                                                _selectedPosition, // The new latitude and longitude
                                            zoom:
                                                15.0, // Set the desired zoom level (for example, 15)
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Spacing.xLarge)),
                                        title: Text(venue.businessName,
                                            style: CustomTypography.title3),
                                        subtitle:
                                            Text(venue.address.join(", ")),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.large),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: SizedBox(
                                          width:
                                              275, // Set the width of the dialog
                                          height: 180,
                                          child: Stack(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Choose Map Style",
                                                    style:
                                                        CustomTypography.title2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.add_road),
                                                        iconSize: 75,
                                                        onPressed: () {
                                                          setState(() {
                                                            userChosenMapType =
                                                                MapType.normal;
                                                          });
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .satellite_alt),
                                                        iconSize: 75,
                                                        onPressed: () {
                                                          setState(() {
                                                            userChosenMapType =
                                                                MapType
                                                                    .satellite;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                  right: 2,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context); // This will close the dialog
                                                      },
                                                      icon: const Icon(
                                                          Icons.close)))
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                icon: const Icon(
                                  Icons.map_outlined,
                                  size: 30,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.my_location,
                                size: 30,
                              ),
                              onPressed: () {
                                _focusNode.unfocus();
                                _moveToCurrentLocation();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]);
    });
  }

  void showLocationModal(
      BuildContext context, LatLng selectedPosition, Venue venue) {
    if (selectedPosition != const LatLng(0, 0)) {
      showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.x2Large),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Spacing.large),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              fit: BoxFit.fitWidth,
                              "https://images.unsplash.com/photo-1731963914155-d22942204d3d?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMnx8fGVufDB8fHx8fA%3D%3D",
                              height: 50,
                            ),
                            const SizedBox(width: Spacing.medium),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(venue.businessName,
                                        style: CustomTypography.title1.copyWith(
                                            color: ColorPalette.primary)),
                                    const SizedBox(width: Spacing.medium),
                                    // Text(venue.businessType, style: CustomTypography.footNote),
                                  ],
                                ),
                                Text(
                                  venue.address.toString(),
                                  style: CustomTypography.footNote,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -Spacing.x2Small),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Spacing.large, vertical: 0),
                    leading: const Icon(Icons.phone),
                    title: Text(venue.phone, style: CustomTypography.body),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -Spacing.x2Small),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Spacing.large, vertical: 0),
                    leading: const Icon(Icons.watch_later),
                    subtitle: Text(venue.openingHours.toString(),
                        style: CustomTypography.body),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -Spacing.x2Small),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Spacing.large, vertical: 0),
                    leading: const Icon(Icons.accessible),
                    title: Text(venue.accessibleParkingAvailable.toString(),
                        style: CustomTypography.body),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -Spacing.x2Small),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Spacing.large, vertical: 0),
                    leading: const Icon(Icons.directions_car),
                    title: Text(venue.closestAccessibleParking.toString(),
                        style: CustomTypography.body),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Spacing.large,
                        right: Spacing.large,
                        top: Spacing.medium),
                    child: CustomPrimaryButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                venue: venue,
                                heroTag: venue.venueId,
                              ),
                            ),
                          );
                        },
                        buttonTitle: "Go to venue"),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
