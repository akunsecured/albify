import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/themes/app_style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyCarouselSlider extends StatefulWidget {
  late final List<String> _urls;
  final bool isRounded;

  MyCarouselSlider({
    required List<dynamic> urls,
    this.isRounded = true
  }) {
    this._urls = urls.cast<String>();
  }

  @override
  State<MyCarouselSlider> createState() => _MyCarouselSliderState();
}

class _MyCarouselSliderState extends State<MyCarouselSlider> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            height: 200,
            viewportFraction: 1,
            autoPlay: widget._urls.length > 1,
            scrollPhysics: widget._urls.length > 1 ? 
              AlwaysScrollableScrollPhysics() :
              NeverScrollableScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _selectedIndex = index;
              });
            }
          ),
          itemCount: widget._urls.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            String url = widget._urls[index];
            return buildImage(url, index);
          },
        ),
        Utils.addVerticalSpace(16),
        buildIndicator(),
      ],      
    );
  }

  Widget buildImage(url, index) =>
    widget.isRounded ?
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
    ) :
    Container(
      color: Colors.grey,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );

  Widget buildIndicator() =>
    AnimatedSmoothIndicator(
      activeIndex: _selectedIndex,
      count: widget._urls.length,
      effect: SlideEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: AppStyle.appColorGreen,
      ),
    );
}