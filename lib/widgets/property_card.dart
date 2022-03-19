import 'dart:ui';

import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    return GestureDetector(
      onTap: () => print(widget.property.id),
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RADIUS)
        ),
        child: Column(
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                height: 200,
                viewportFraction: 1,
                autoPlay: widget.property.photoUrls.length > 1,
                scrollPhysics: widget.property.photoUrls.length > 1 ? 
                  AlwaysScrollableScrollPhysics() :
                  NeverScrollableScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              ),
              itemCount: widget.property.photoUrls.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                String url = widget.property.photoUrls[index];
                return buildImage(url, index);
              },
            ),
            Utils.addVerticalSpace(16),
            buildIndicator(),
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

  Widget buildImage(url, index) =>
    ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(RADIUS),
        topRight: Radius.circular(RADIUS)
      ),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  
  Widget buildIndicator() =>
    AnimatedSmoothIndicator(
      activeIndex: _selectedIndex,
      count: widget.property.photoUrls.length,
      effect: SlideEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: AppStyle.appColorGreen,
      ),
    );
}