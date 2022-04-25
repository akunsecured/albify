import 'package:albify/models/message_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:flutter/foundation.dart';

class ConversationProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  ConversationProvider(this.databaseService);

  Stream<List<ConversationModel>> conversations() =>
      databaseService.conversationsStream().map((snapshot) => snapshot.docs
          .map((conversation) =>
              ConversationModel.fromDocumentSnapshot(conversation))
          .toList());
}
