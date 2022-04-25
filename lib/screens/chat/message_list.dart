import 'package:albify/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_element.dart';

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MessageModel> messages = Provider.of<List<MessageModel>>(context);
    return ListView(
      children: messages
          .map((message) => MessageElement(chatElement: message))
          .toList(),
    );
  }
}
