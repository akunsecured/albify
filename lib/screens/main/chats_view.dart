import 'package:albify/models/message_model.dart';
import 'package:albify/providers/conversation_provider.dart';
import 'package:albify/screens/main/conversation_element.dart';
import 'package:albify/screens/main/conversation_list.dart';
import 'package:albify/screens/main/login_is_needed.dart';
import 'package:albify/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsView extends StatefulWidget {
  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
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
        ChangeNotifierProvider(
          create: (_) => ConversationProvider(Provider.of<DatabaseService>(context, listen: false)),
          builder: (context, child) =>
              StreamProvider<List<ConversationModel>>.value(
                value: Provider.of<ConversationProvider>(context, listen: false).conversations(),
                initialData: [],
                child: ConversationList(),
              )
        ),
    );
  }

  List<ConversationModel> conversationsFromQuerySnapshot(
      QuerySnapshot<Object?> data
    ) => data.docs.map(
            (document) => ConversationModel.fromDocumentSnapshot(document)
    ).toList();

  Widget buildConversations() {
    List<ConversationModel> conversations = Provider.of<List<ConversationModel>>(context);
    return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) =>
          ConversationElement(conversationModel: conversations[index])
    );
  }
}