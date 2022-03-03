import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  SharedPreferences? _sharedPreferences;
  late GoogleMapController _mapController;

  LatLng? _center;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _center!,
        zoom: 15.0
      )
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: getLocation(),
          builder: (BuildContext context, AsyncSnapshot<LatLng?> snapshot) {
            if (snapshot.hasError) {
              return Align(
                alignment: Alignment.center,
                child: MyText(
                  text: 'Error'
                ),
              );
            }

            if (
              snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active
            ) {
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: AppStyle.appColorGreen,
                )
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: snapshot.data ?? _center!,
                  zoom: 15.0
                ),
              );
            }
            
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppStyle.appColorGreen,
              )
            );
          }
        ),
      ),
    );
  }

  Future<LatLng?> getLocation() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    double? lastLat = _sharedPreferences!.getDouble('lastLat');
    double? lastLng = _sharedPreferences!.getDouble('lastLng');

    if (lastLat == null && lastLng == null) {
      _center = LatLng(47.4733413,19.0597962);
    } else {
      _center = LatLng(lastLat!, lastLng!);
    }
    
    Location location = Location();

    var _permissionGranted = await location.hasPermission();
    var _serviceEnabled = await location.serviceEnabled();

    if (_permissionGranted != PermissionStatus.granted || !_serviceEnabled) {
      _permissionGranted = await location.requestPermission();
      _serviceEnabled = await location.requestService();
    }

    try {
      final LocationData currentPosition = await location.getLocation();
      LatLng? center;
      if (currentPosition.latitude != null && currentPosition.longitude != null) {
        center = LatLng(
          currentPosition.latitude!,
          currentPosition.longitude!
        );
        _sharedPreferences!.setDouble('lastLat', center.latitude);
        _sharedPreferences!.setDouble('lastLng', center.longitude);

        // We have the user's location
        return center;
      }
    } catch (e) {
      print (e);
      // Could not get the location
      return null;
    }

    // Could not get the location
    return null;
  }
}