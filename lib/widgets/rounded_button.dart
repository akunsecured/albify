import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  String text;
  Function() onPressed;
  bool outlined;
  Color? primary;
  double? width;

  RoundedButton(
    this.text,
    this.onPressed,
    {
      this.outlined = false,
      this.primary,
      this.width
    }
  ) {
    if (primary == null)
      primary = AppStyle.appColorBlack;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: this.onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: outlined ? Colors.black : Colors.white
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: outlined ? Colors.white : primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: outlined ? BorderSide(
              color: primary!,
              width: 2
            ) : BorderSide.none
          )
        ),
      ),
    );
  }
}