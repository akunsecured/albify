import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  late final String text;
  late final Color? color;
  late final double? fontSize;
  late final FontWeight? fontWeight;

  MyText({
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: this.color ?? Colors.white,
        fontSize: this.fontSize ?? 16,
        fontWeight: this.fontWeight ?? FontWeight.normal
      ),
    );
  }
}