import 'package:flutter/material.dart';

class MyRangeSlider extends StatefulWidget {
  final double min, max, minValue, maxValue;
  final int divisions;
  final bool hasSlideLabel;
  final String? suffix, title;
  late RangeValues rangeSliderDiscreteValues;

  MyRangeSlider({
    this.min = 0,
    this.max = 100,
    this.divisions = 50,
    this.minValue = 0,
    this.maxValue = 100,
    this.hasSlideLabel = false,
    this.suffix,
    this.title
  }) {
    rangeSliderDiscreteValues = RangeValues(min, max);
  }

  @override
  State<MyRangeSlider> createState() => _MyRangeSliderState();
}

class _MyRangeSliderState extends State<MyRangeSlider> {
  @override
  Widget build(BuildContext context) {
    RangeSlider rangeSlider = RangeSlider(
      values: widget.rangeSliderDiscreteValues,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      labels: RangeLabels(
          (widget.rangeSliderDiscreteValues.start.round() *
                  0.01 *
                  widget.maxValue)
              .toString(),
          (widget.rangeSliderDiscreteValues.end.round() *
                  0.01 *
                  widget.maxValue)
              .toString()),
      onChanged: (values) {
        setState(() {
          widget.rangeSliderDiscreteValues = values;
        });
      },
    );

    if (widget.suffix != null || widget.hasSlideLabel) {
      return Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            widget.title != null ?
            Container(
              margin: EdgeInsets.all(8),
              child: Text(
                widget.title!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
            ) :
            Container(),
            rangeSlider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      widget.suffix != null ?
                      '${widget.minValue} ${widget.suffix}' :
                      '${widget.minValue}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Text(
                      widget.suffix != null ?
                      '${widget.maxValue} ${widget.suffix}' :
                      '${widget.maxValue}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ],
        ),
      );
    }

    return Container(margin: EdgeInsets.all(8), child: rangeSlider);
  }
}
