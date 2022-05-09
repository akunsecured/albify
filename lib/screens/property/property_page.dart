import 'dart:ui';

import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/screens/chat/chat_screen.dart';
import 'package:albify/screens/property/property_map_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_alert_dialog.dart';
import 'package:albify/widgets/my_carousel_slider.dart';
import 'package:albify/widgets/my_google_map.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  late DatabaseService databaseService;
  late Future<UserModel?> future;
  late LatLng position;
  late Size _size;
  UserModel? userModel;
  late User? currentUser;

  @override
  void initState() {
    this.position = LatLng(
      widget.property.location.lat,
      widget.property.location.lng
    );
    databaseService = Provider.of<DatabaseService>(context, listen: false);
    future = databaseService.getUserData(userID: widget.property.ownerID);
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.property.location.locationName ?? 'Unknown location'
        ),
        actions: currentUser!.uid == widget.property.ownerID ?
          [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => MyAlertDialog(
                    title: 'Deleting property',
                    content: 'Are you sure you want to delete this property?',
                    onPositiveButtonPressed: () async {
                      databaseService.deleteProperty(widget.property)
                      .then((success) => onDelete(success));
                    },
                    onNegativeButtonPressed: () => Navigator.of(context).pop()
                )
              ),
              icon: Icon(Icons.delete)
            )
          ] :
          [],
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
              userModel = snapshot.data;
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
                    children: getActionButtons(),
                  ),
                  Divider(),
                  MyText(
                    text: 'Details',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
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
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          CustomPageRouteBuilder(
                            child: PropertyMapPage(property: widget.property),
                            direction: SlideDirections.FROM_DOWN
                          )
                        ),
                        child: AbsorbPointer(
                          child: MyGoogleMap(
                            center: position,
                            isNotLocked: false,
                            markers: [
                              Marker(
                                markerId: MarkerId(widget.property.id!),
                                position: position
                              )
                            ].toSet(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  
  List<Widget> getActionButtons() {
    if (kIsWeb) {
      return currentUser!.uid != widget.property.ownerID ? [
        buildChatButton(2.5),
        buildFavoriteButton(2.5)
      ] :
      [
        buildEditButton(2.5)
      ];
    } else {
      var buttons = <Widget>[];
      if (currentUser!.uid == widget.property.ownerID) {
        buttons.add(buildEditButton(2.5, iconOnly: true));
      } else {
        buttons.add(buildChatButton(4.5, iconOnly: true));
        if (userModel?.phoneNumber != null && userModel?.phoneNumber != -1) {
          buttons.add(buildCallButton(4.5, iconOnly: true));
        }
        buttons.add(buildFavoriteButton(4.5, iconOnly: true));
      }
      return buttons;
    }
  }

  Widget buildChatButton(double divider, { bool iconOnly = false }) =>
    Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8
      ),
      child: RoundedButton(
        text: 'Chat',
        icon: Icons.chat,
        isItNavigation: false,
        width: getPreferredSize(_size) / divider,
        iconOnly: iconOnly,
        onPressed: () async {
          var conversationID = await Provider.of<DatabaseService>(context, listen: false)
              .findOrCreateConversation(widget.property.ownerID!);
          Navigator.push(
              context,
              CustomPageRouteBuilder(
                  child: ChatScreen(conversationId: conversationID),
                  direction: SlideDirections.FROM_LEFT
              )
          );
        },
      ),
    );

  Widget buildCallButton(double divider, { bool iconOnly = false }) =>
    Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8
      ),
      child: RoundedButton(
        text: 'Call',
        icon: Icons.call,
        isItNavigation: false,
        width: getPreferredSize(_size) / divider,
        iconOnly: iconOnly,
      ),
    );
  
  Widget buildFavoriteButton(double divider, { bool iconOnly = false }) =>
    Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8
      ),
      child: userModel!.favoritePropertyIDs!.cast<String>().contains(widget.property.id) ?
        RoundedButton(
          text: 'Favorites',
          icon: Icons.star,
          isItNavigation: false,
          width: getPreferredSize(_size) / divider,
          iconOnly: iconOnly,
          onPressed: () {
            // TODO: add to favorites
          },
        ) :
        RoundedButton(
          text: 'Favorites',
          icon: Icons.star_outline,
          isItNavigation: false,
          width: getPreferredSize(_size) / divider,
          iconOnly: iconOnly,
          onPressed: () {
            // TODO: remove from favorites
          },
        ),
    );

  Widget buildEditButton(double divider, { bool iconOnly = false }) =>
    RoundedButton(
      text: 'Edit',
      icon: Icons.edit,
      isItNavigation: false,
      width: getPreferredSize(_size) / divider,
      iconOnly: iconOnly,
    );

  void onDelete(bool success) {
    Navigator.of(context).pop();
    if (success) {
      Navigator.of(context).pop(true);
    }
  }
}