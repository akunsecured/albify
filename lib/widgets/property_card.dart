import 'dart:ui';

import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/common/constants.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/screens/property/property_page.dart';
import 'package:albify/widgets/my_carousel_slider.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatefulWidget {
  final PropertyModel property;

  PropertyCard(
    this.property
  );

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => 
        Navigator.push(
          context,
          CustomPageRouteBuilder(
            child: PropertyPage(property: widget.property),
            direction: SlideDirections.FROM_DOWN
          )
        ),
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RADIUS)
        ),
        child: Column(
          children: [
            MyCarouselSlider(urls: widget.property.photoUrls),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: '${widget.property.price} Ft',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                      IconButton(
                        iconSize: 36,
                        onPressed: () {}, 
                        icon: Icon(Icons.star_border)
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          MyText(
                            text: 'Floorspace',
                            color: Colors.grey[400],
                          ),
                          Row(
                            children: [
                              MyText(
                                text: '${widget.property.floorspace} m',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              Text(
                                '2',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [
                                    FontFeature.superscripts()
                                  ]
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          MyText(
                            text: 'Rooms',
                            color: Colors.grey[400],
                          ),
                          MyText(
                            text: '${widget.property.rooms}',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}