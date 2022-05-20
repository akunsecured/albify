import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  const MyCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: AppStyle.appColorGreen,
      ));
}
