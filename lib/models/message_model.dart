import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String sentBy, message;
  int? timeStamp;
  int sentFromClient;

  MessageModel(
      {required this.sentBy,
      required this.message,
      required this.sentFromClient,
      this.timeStamp});

  factory MessageModel.fromDocumentSnapshot(
          DocumentSnapshot documentSnapshot) =>
      MessageModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
      sentBy: map['sentBy'],
      message: map['message'],
      sentFromClient: map['sentFromClient'],
      timeStamp:
          (map['timeStamp'] as Timestamp?)?.toDate().millisecondsSinceEpoch);

  Map<String, dynamic> toMap() => {
        'sentBy': sentBy,
        'message': message,
        'sentFromClient': sentFromClient,
        'timeStamp': timeStamp
      };
}

class ConversationModel {
  String? id;
  List participants;
  MessageModel? lastMessage;

  ConversationModel({required this.participants, this.id, this.lastMessage});

  factory ConversationModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return ConversationModel(
        id: documentSnapshot.id,
        participants: data['participants'],
        lastMessage: data['lastMessage'] != null
            ? MessageModel.fromMap(data['lastMessage'])
            : null);
  }

  Map<String, dynamic> toMap() =>
      {'participants': participants, 'lastMessage': lastMessage?.toMap()};
}
