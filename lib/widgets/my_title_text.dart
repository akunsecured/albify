import 'package:flutter/material.dart';

class MyTitleText extends StatelessWidget {
  final String title;
  final bool withContainer;
  final Color color;
  final double? fontSize;

  const MyTitleText(
      {Key? key,
      required this.title,
      this.withContainer = true,
      this.color = Colors.black,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) => withContainer
      ? Container(
          margin: EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? 18,
                color: color),
          ),
        )
      : Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 18,
              color: color),
        );
}
