import 'package:albify/models/property_model.dart';
import 'package:albify/widgets/my_google_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PropertyMapPage extends StatelessWidget {
  final PropertyModel property;

  PropertyMapPage({
    required this.property
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(property.location.locationName ?? 'Unknown location'),
      ),
      body: MyGoogleMap(
        center: LatLng(property.location.lat, property.location.lng),
        markers: [
          Marker(
            markerId: MarkerId(property.id!),
            position: LatLng(
              property.location.lat,
              property.location.lng
            ),
            infoWindow: InfoWindow(
              title: property.location.locationName ?? 'Unknown location'
            )
          )
        ].toSet(),
      ),
    );
  }
}