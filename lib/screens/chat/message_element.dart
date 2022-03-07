import 'dart:math';

import 'package:albify/common/constants.dart';
import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class MessageElement extends StatefulWidget {
  @override
  _MessageElementState createState() => _MessageElementState();
}

class _MessageElementState extends State<MessageElement> {
  late bool sender;

  @override
  void initState() {
    sender = Random().nextBool();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14
      ),
      child: Align(
        alignment: sender ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.2,
            maxWidth: MediaQuery.of(context).size.width * 0.8
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            getRandomString(),
            style: TextStyle(
              color: Colors.white
            ),
          ),
          decoration: BoxDecoration(
            borderRadius:
              BorderRadius.only(
                topLeft: Radius.circular(RADIUS),
                topRight: Radius.circular(RADIUS),
                bottomLeft: sender ? Radius.circular(SENDER_RADIUS) : Radius.circular(RADIUS),
                bottomRight: sender ? Radius.circular(RADIUS) : Radius.circular(SENDER_RADIUS)
              ),
            color: sender ? Colors.grey.shade600 : AppStyle.appColorGreen
          ),
        ),
      ),
    );
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString() => 
    String.fromCharCodes(
      Iterable.generate(
        Random().nextInt(50),
        (_) => _chars.codeUnitAt(
          Random().nextInt(_chars.length)
        )
      )
    );
}