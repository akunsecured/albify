import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Map<String, Marker> _markers = {};
  late final GoogleMapController _mapController;

  final LatLng _center = const LatLng(47.4733413,19.0597962);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _markers.clear();
      _markers["0"] = Marker(
        markerId: MarkerId("0"),
        position: _center
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}