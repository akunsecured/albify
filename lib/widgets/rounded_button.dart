import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool outlined;
  Color? primary;
  final double? width;
  final FocusNode? focusNode;

  RoundedButton(
    this.text,
    this.onPressed,
    {
      this.outlined = false,
      this.primary,
      this.width,
      this.focusNode
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
        focusNode: focusNode,
      ),
    );
  }
}