import 'package:albify/screens/main/conversation_element.dart';
import 'package:albify/screens/main/login_is_needed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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
        Container(
        //   child: ListView.builder(
        //     itemCount: 5,
        //     itemBuilder: (context, index) {
        //       return ConversationElement();
        //   }
        // ),
      ),
    );
  }
}