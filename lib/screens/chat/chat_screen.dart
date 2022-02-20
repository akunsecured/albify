import 'package:albify/common/utils.dart';
import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

import 'message_element.dart';

class ChatScreen extends StatefulWidget {
  static const String ROUTE_ID = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Name'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) =>
              MessageElement(

              )
          ),
          Utils.addVerticalSpace(12),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: AppStyle.appColorBlack,
              padding: EdgeInsets.all(16),
              height: 60,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Message ...',
                          hintStyle: TextStyle(color: Colors.white54),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Utils.addHorizontalSpace(15),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.send),
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}
