import 'package:albify/widgets/my_google_map.dart';
import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: MyGoogleMap(),
      ),
    );
  }
}
