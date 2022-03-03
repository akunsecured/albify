import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyle.appColorBlack,
      child: Center(
        child: CircularProgressIndicator(
          color: AppStyle.appColorGreen,
        ),
      ),
    );
  }
}