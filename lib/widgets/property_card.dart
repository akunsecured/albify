import 'dart:ui';

import 'package:albify/common/constants.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/widgets/my_carousel_slider.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatefulWidget {
  final PropertyModel property;
  final VoidCallback? onTap;

  PropertyCard(
    this.property,
    {
      this.onTap
    }
  );

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap!();
      },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: widget.property.location.locationName ?? 'Unknown location',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                    maxLines: 1,
                  ),
                  MyText(
                    text: '${widget.property.price} Ft',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
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