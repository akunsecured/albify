import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/screens/property/property_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGoogleMap extends StatefulWidget {
  final LatLng? center;
  final Set<Marker>? markers;
  final bool isNotLocked;
  final bool onTapPlaceMarker;
  final Function(LatLng)? onTap;

  MyGoogleMap({
    this.center,
    this.markers,
    this.isNotLocked = true,
    this.onTapPlaceMarker = false,
    this.onTap
  });

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  late Future<dynamic> future;
  SharedPreferences? _sharedPreferences;
  LatLng? _center;
  Set<Marker>? _markers;

  @override
  void initState() {
    future = buildGoogleMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
          var googleMap = GoogleMap(
            initialCameraPosition: CameraPosition(
              target: snapshot.data['location'] ?? _center!,
              zoom: 15.0
            ),
            markers: _markers ?? (snapshot.data['markers'] ?? Set()),
            zoomGesturesEnabled: widget.isNotLocked,
            scrollGesturesEnabled: widget.isNotLocked,
            tiltGesturesEnabled: widget.isNotLocked,
            rotateGesturesEnabled: widget.isNotLocked,
            zoomControlsEnabled: widget.isNotLocked,
            onTap: widget.onTapPlaceMarker ?
              handleTap :
              null,
          );

          return googleMap;
        }
        
        return Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: AppStyle.appColorGreen,
          )
        );
      }
    );
  }

  handleTap(LatLng tappedPoint) {
    print(tappedPoint);
    if (widget.onTap != null) widget.onTap!(tappedPoint);
    setState(() {
      _markers = Set();
      _markers!.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint
        )
      );
    });
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
    } on Exception catch (e) {
      print(e.toString());
      // Could not get the location
      return null;
    }

    // Could not get the location
    return null;
  }

  Future<Set<Marker>> getMarkers() async {
    final DatabaseService _databaseService = Provider.of<DatabaseService>(context, listen: false);
    List<PropertyModel> properties = await _databaseService.getAllProperties();
    print(properties);
    return properties
        .map((property) => Marker(
          markerId: MarkerId(property.id!),
          position: LatLng(property.location.lat, property.location.lng),
          infoWindow: InfoWindow(
            title: property.location.locationName ?? 'Unknown location',
            onTap: () => Navigator.push(
              context,
              CustomPageRouteBuilder(
                child: PropertyPage(property: property),
                direction: SlideDirections.FROM_DOWN
              )
            )
          )
        )).toSet();
  }

  Future<dynamic> buildGoogleMap() async {
    LatLng? location = widget.center;
    if (location == null) await getLocation();
    if (_markers == null) _markers = widget.markers;
    if (_markers == null) _markers = await getMarkers();
    return {
      'location': location,
      'markers': _markers
    };
  }
}