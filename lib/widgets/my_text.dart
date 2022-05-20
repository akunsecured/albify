import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  late final String text;
  late final Color? color;
  late final double? fontSize;
  late final FontWeight? fontWeight;
  late final EdgeInsetsGeometry? margin;
  late final int? maxLines;

  MyText(
      {required this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.margin,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: this.color ?? Colors.white,
            fontSize: this.fontSize ?? 16,
            fontWeight: this.fontWeight ?? FontWeight.normal),
      ),
    );
  }
}
