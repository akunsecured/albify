import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/widgets/my_google_map.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationDialog extends StatefulWidget {
  @override
  State<SelectLocationDialog> createState() => _SelectLocationDialogState();
}

class _SelectLocationDialogState extends State<SelectLocationDialog> {
  LatLng? selectedPoint;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RADIUS)
      ),
      elevation: 0,
      content: Center(
        child: Container(
          width: getPreferredSize(_size),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(RADIUS),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 3/4,
                  child: MyGoogleMap(
                    markers: Set(),
                    onTapPlaceMarker: true,
                    onTap: onTap,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(MARGIN_HORIZONTAL),
                    child: RoundedButton(
                      text: 'Select location',
                      onPressed: () {
                        if (selectedPoint == null) {
                          Utils.showToast('Select a location!');
                        } else {
                          Navigator.pop(context, selectedPoint);
                        }
                      },
                    ),
                  ),
                )
              ]
            ),
          )
        ),
      )
    );
  }

  onTap(LatLng position) {
    setState(() {
      this.selectedPoint = position;
    });
  }
}