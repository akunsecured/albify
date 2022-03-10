import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ConversationElement extends StatefulWidget {
  @override
  _ConversationElementState createState() => _ConversationElementState();
}

class _ConversationElementState extends State<ConversationElement> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatScreen.ROUTE_ID
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MARGIN_HORIZONTAL,
          vertical: 10
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/albify_icon.png'),
                    maxRadius: 30,
                  ),
                  Utils.addHorizontalSpace(16),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                          Utils.addVerticalSpace(6),
                          Text(
                            'Last message',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Text(
                    'Time',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}