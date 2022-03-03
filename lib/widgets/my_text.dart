import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  late final String text;

  MyText({
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16
      ),
    );
  }
}