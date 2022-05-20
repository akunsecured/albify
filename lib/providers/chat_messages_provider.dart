import 'package:albify/models/message_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ChatMessagesProvider extends ChangeNotifier {
  final String conversationID;
  final DatabaseService databaseService;

  ChatMessagesProvider(this.databaseService, {required this.conversationID});

  Stream<List<MessageModel>> messages() => databaseService
      .messagesStream(conversationID)
      .map((snapshot) => snapshot.docs
          .map((message) => MessageModel.fromDocumentSnapshot(message))
          .toList());
}
