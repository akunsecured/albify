import 'package:albify/models/property_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
    if (value.length < 6)
      return 'Password should be at least 6 characters';
    return null;
  }

  static validateName(String? value) {
    if (value == null || value.isEmpty)
      return 'Name must be filled';
    if (value.length < 2)
      return 'Name should be at least 2 characters';
    return null;
  }

  static validateConfirmPassword(String? value, String? matchWith) {
    print("Matchwith: $matchWith");
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

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static validatePrice(String? value) {
    if (value == null || value.isEmpty)
      return 'Price must be filled';
    if (int.parse(value) < 1)
      return 'Price must be positive number';
    return null;
  }

  static validateRooms(String? value) {
    if (value == null || value.isEmpty)
      return 'Rooms must be filled';
    if (int.parse(value) < 1)
      return 'Rooms must be positive number';
    return null;
  }

  static validateFloorspace(String? value) {
    if (value == null || value.isEmpty)
      return 'Floorspace must be filled';
    if (double.parse(value) < 1)
      return 'Floorspace must be positive number';
    return null;
  }

  static validateDescription(String? value) {
    if (value == null || value.isEmpty)
      return 'Description must be written';
    return null;
  }

  static enumToString(PropertyType enumValue) {
    var temp = enumValue.toString().split('.')[1];
    return temp.substring(0, 1) + temp.toLowerCase().substring(1);
  }

  static String formatDate(int dateInInt) {
    final DateTime now = DateTime.now();
    final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    final DateTime twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
    final DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
    var date = DateTime.fromMillisecondsSinceEpoch(dateInInt);
    if (date.isBefore(now) && date.isAfter(yesterday)) {
      return DateFormat.jm().format(date);
    } else if (date.isBefore(yesterday) && date.isAfter(twoDaysAgo)) {
      return 'Yesterday ${DateFormat.jm().format(date)}';
    } else if (date.isBefore(twoDaysAgo) && date.isAfter(oneWeekAgo)) {
      return DateFormat.E().add_jm().format(date);
    } else {
      return DateFormat.yMMMd().add_jm().format(date);
    }
  }
}