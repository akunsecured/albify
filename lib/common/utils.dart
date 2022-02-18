import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static RegExp emailRegExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp passwordRegExp = RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?/~_+-=|\]).{6,20}$');

  static validateEmail(String? value) {
    if (value == null || value.isEmpty)
      return 'Email must be filled';
    if (!Utils.emailRegExp.hasMatch(value))
      return 'Email is badly formatted';
    return null;
  }

  static validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Password must be filled';
    return null;
  }

  static validateName(String? value) {
    if (value == null || value.isEmpty)
      return 'Name must be filled';
    return null;
  }

  static validateConfirmPassword(String? value, String? matchWith) {
    if (value == null || value.isEmpty)
      return 'Confirm password must be filled';
    if (value != matchWith)
      return 'Passwords do not match';
    return null;
  }

  static Widget addVerticalSpace(double height) {
    return SizedBox(height: height);
  }

  static Widget addHorizontalSpace(double width) {
    return SizedBox(width: width);
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(30),
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.only(
                      left: 16
                    ),
                    child: Text('Loading ...')
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}