import 'dart:ui';

import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_carousel_slider.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PropertyPage extends StatefulWidget {
  final PropertyModel property;

  PropertyPage({
    required this.property
  });

  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  late Future<UserModel?> future;
  late GoogleMapController _mapController;
  late LatLng position;
  late Size _size;

  @override
  void initState() {
    this.position = LatLng(
      widget.property.location.lat,
      widget.property.location.lng
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._size = MediaQuery.of(context).size;
    future = Provider.of<DatabaseService>(context, listen: false).getUserData(userID: widget.property.ownerID);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // TODO: show the location name
          'Property'
        ),
      ),
      body: FutureBuilder(
        future: this.future,
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
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
            if (snapshot.data != null) {
              return buildPropertyPage();
            }
            else {
              return Align(
                alignment: Alignment.center,
                child: MyText(
                  text: "Error"
                )
              );
            }
          }

          return Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: AppStyle.appColorGreen,
            )
          );
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  Widget buildPropertyPage() =>
    SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            MyCarouselSlider(
              urls: widget.property.photoUrls,
              isRounded: false,
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: '${widget.property.price} Ft',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO: buttons
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8
                        ),
                        child: RoundedButton(
                          text: 'Chat',
                          icon: Icons.chat,
                          isItNavigation: false,
                          width: getPreferredSize(_size) / 2.5,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8
                        ),
                        child: RoundedButton(
                          text: 'Call',
                          icon: Icons.call,
                          isItNavigation: false,
                          width: getPreferredSize(_size) / 2.5,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  MyText(
                    text: 'Details',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  // TODO: details
                  Table(
                    children: [
                      TableRow(
                        children: [
                          MyText(
                            text: 'Rooms',
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                          MyText(
                            text: '${widget.property.rooms}',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                        ]
                      ),
                      TableRow(
                        children: [
                          MyText(
                            text: 'Floorspace',
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                          Row(
                            children: [
                              MyText(
                                text: '${widget.property.floorspace} m',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                margin: EdgeInsets.symmetric(
                                  vertical: 8.0
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 8.0
                                ),
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFeatures: [
                                      FontFeature.superscripts()
                                    ]
                                  ),
                                ),
                              )
                            ],
                          )
                        ]
                      ),
                      TableRow(
                        children: [
                          MyText(
                            text: 'Type',
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                          MyText(
                            text: '${Utils.enumToString(widget.property.type)}',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                        ]
                      ),
                      TableRow(
                        children: [
                          MyText(
                            text: 'Newly built?',
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                          MyText(
                            text: widget.property.newlyBuilt ? 'Yes' : 'No',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                        ]
                      ),
                      TableRow(
                        children: [
                          MyText(
                            text: 'For sale?',
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                          MyText(
                            text: widget.property.forSale ? 'Yes' : 'No',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                  Divider(),
                  MyText(
                    text: 'Description',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0
                    ),
                  ),
                  MyText(
                    text: widget.property.description,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0
                    ),
                  ),
                  Divider(),
                  MyText(
                    text: 'Map',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(RADIUS)
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: position,
                          zoom: 15.0
                        ),
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        markers: [
                          Marker(
                            markerId: MarkerId(widget.property.id!),
                            position: position
                          )
                        ].toSet(),
                      ),
                    ),
                  )
                ]
              ),
            ),
            
          ],
        ),
      ),
    );
}