import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class FullScreen360View extends StatelessWidget {
  final String imageURL;

  const FullScreen360View({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("360 View"),
      ),
      body: Center(
        child: PanoramaViewer(
          child: Image.network(imageURL),
        ),
      ),
    );
  }
}
