import 'package:albify/common/constants.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onPositiveButtonPressed;
  final Function() onNegativeButtonPressed;

  MyAlertDialog({
    required this.title,
    required this.content,
    required this.onPositiveButtonPressed,
    required this.onNegativeButtonPressed
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RADIUS)
      ),
      elevation: 0,
      actions: [
        TextButton(
          onPressed: this.onPositiveButtonPressed,
          child: Text('Yes')
        ),
        TextButton(
          onPressed: this.onNegativeButtonPressed,
          child: Text('No')
        ),
      ],
    );
  }
}