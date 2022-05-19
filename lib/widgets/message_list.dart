import 'package:albify/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_element.dart';

class MessageList extends StatelessWidget {
  final ScrollController controller;
  const MessageList({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MessageModel> messages = Provider.of<List<MessageModel>>(context);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
    return ListView(
      controller: controller,
      children: messages
          .map((message) => MessageElement(chatElement: message))
          .toList().reversed.toList(),
    );
  }
}
