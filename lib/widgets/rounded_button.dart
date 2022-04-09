import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final bool isItNavigation;
  final Function()? onPressed;
  final bool outlined;
  Color? primary;
  final double? width;
  final FocusNode? focusNode;
  final bool iconOnly;

  RoundedButton({
    this.icon,
    this.text = '',
    this.isItNavigation = true,
    this.onPressed,
    this.outlined = false,
    this.primary,
    this.width,
    this.focusNode,
    this.iconOnly = false
  }) {
    if (primary == null)
      primary = AppStyle.appColorBlack;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: this.onPressed ?? () => {},
        child: icon == null ?
          Text(
            text,
            style: TextStyle(
              color: outlined ? Colors.black : Colors.white
            ),
          ) :
          (
            this.iconOnly ?
            Icon(icon) :
            (
              this.isItNavigation ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(this.icon),
                      Utils.addHorizontalSpace(10),
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                  Icon(Icons.chevron_right)
                ],
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(this.icon),
                  Utils.addHorizontalSpace(10),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              )
            )
          ),
        style: ElevatedButton.styleFrom(
          primary: outlined ? Colors.white : primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RADIUS),
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