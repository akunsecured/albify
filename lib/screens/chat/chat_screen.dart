import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/message_model.dart';
import 'package:albify/providers/chat_messages_provider.dart';
import 'package:albify/screens/chat/message_list.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_circular_progress_indicator.dart';
import 'package:albify/widgets/my_error_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String ROUTE_ID = '/chat';
  final String conversationId;
  final String? nameOfUser;

  ChatScreen({this.conversationId = '', this.nameOfUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late DatabaseService _databaseService;
  late Future<String?> future;
  late Stream<QuerySnapshot?> stream;
  late TextEditingController messageController;
  late ScrollController listScrollController;

  @override
  void initState() {
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    future = _databaseService.getOtherUserName(widget.conversationId);
    stream = _databaseService.messagesStream(widget.conversationId);
    messageController = TextEditingController();
    listScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.nameOfUser == null
        ? FutureBuilder<String?>(
            future: future,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Error'),
                    centerTitle: true,
                  ),
                  body: MyErrorPrinter(error: snapshot.error),
                );
              }

              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                return Scaffold(
                  body: MyCircularProgressIndicator(),
                );
              }

              return buildPage(snapshot.data!);
            })
        : buildPage(widget.nameOfUser!);
  }

  List<MessageModel> messagesFromQuerySnapshot(QuerySnapshot data) => data.docs
      .map((document) => MessageModel.fromDocumentSnapshot(document))
      .toList();

  Widget buildPage(String name) => Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ChangeNotifierProvider(
              create: (_) => ChatMessagesProvider(
                  Provider.of<DatabaseService>(context, listen: false),
                  conversationID: widget.conversationId),
              builder: (context, child) =>
                  StreamProvider<List<MessageModel>>.value(
                value: Provider.of<ChatMessagesProvider>(context, listen: false)
                    .messages(),
                initialData: [],
                child: MessageList(controller: listScrollController),
              ),
            ),
          ),
          Utils.addVerticalSpace(12),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                color: AppStyle.appColorBlack,
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: getMessageInput(),
                    ),
                    Utils.addHorizontalSpace(MARGIN_HORIZONTAL),
                    InkWell(
                      onTap: () {
                        if (messageController.text.trim().isNotEmpty) {
                          Provider.of<DatabaseService>(context, listen: false)
                              .sendMessage(
                                  conversationID: widget.conversationId,
                                  message: messageController.text.trim());
                          messageController.clear();
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                )),
          )
        ],
      ));

  OutlineInputBorder getBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(RADIUS),
      borderSide: BorderSide(color: Colors.white));

  Widget getMessageInput() => TextFormField(
        controller: messageController,
        minLines: 1,
        maxLines: 3,
        decoration: InputDecoration(
            border: getBorder(),
            focusedBorder: getBorder(),
            enabledBorder: getBorder(),
            hintText: 'Message ...',
            hintStyle: TextStyle(color: Colors.white)),
        style: TextStyle(color: Colors.white),
      );
}
