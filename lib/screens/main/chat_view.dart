import 'package:albify/models/message_model.dart';
import 'package:albify/screens/main/conversation_element.dart';
import 'package:albify/screens/main/login_is_needed.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_circular_progress_indicator.dart';
import 'package:albify/widgets/my_error_printer.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    stream = Provider.of<DatabaseService>(context, listen: false)
      .conversationsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Chats'),
      ),
      body: FirebaseAuth.instance.currentUser!.isAnonymous ?
        Center(child: LoginIsNeeded()) :
        StreamBuilder(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            if (snapshot.hasError) {
              return MyErrorPrinter(error: snapshot.error);
            }

            if (
            snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting
            ) {
              return MyCircularProgressIndicator();
            }

            if (snapshot.data!.docs.isEmpty) {
              return Align(
                alignment: Alignment.center,
                child: MyText(
                    text: "There are no conversations"
                ),
              );
            }

            var conversations = conversationsFromQuerySnapshot(snapshot.data!);
            return buildConversations(conversations);
          }
        ),
    );
  }

  List<ConversationModel> conversationsFromQuerySnapshot(
      QuerySnapshot<Object?> data
    ) => data.docs.map(
            (document) => ConversationModel.fromDocumentSnapshot(document)
    ).toList();


  Widget buildConversations(List<ConversationModel> conversations) =>
      ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) =>
              ConversationElement(
                  conversationModel: conversations[index]
              )
      );
}