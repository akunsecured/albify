import 'package:albify/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'conversation_element.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ConversationModel> conversations =
        Provider.of<List<ConversationModel>>(context);
    return ListView(
      children: conversations
          .map((conversation) => ConversationElement(
              conversationModel: conversation, key: ValueKey(conversation.id)))
          .toList(),
    );
  }
}
