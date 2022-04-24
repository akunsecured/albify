import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/message_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/screens/chat/chat_screen.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/my_circle_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationElement extends StatefulWidget {
  final ConversationModel conversationModel;

  ConversationElement({required this.conversationModel});

  @override
  _ConversationElementState createState() => _ConversationElementState();
}

class _ConversationElementState extends State<ConversationElement> {
  late User currentUser;
  late Future<UserModel?> future;
  late DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  String getUserID(List participants) {
    for (var participant in participants) {
      if (participant != currentUser.uid) {
        return participant;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var otherUserID = getUserID(widget.conversationModel.participants);
    future = _databaseService.getUserData(userID: otherUserID);
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }

        var userModel = snapshot.data!;

        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                CustomPageRouteBuilder(
                    child: ChatScreen(
                      conversationId: widget.conversationModel.id!,
                      nameOfUser: userModel.name,
                    ),
                    direction: SlideDirections.FROM_LEFT));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MARGIN_HORIZONTAL, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    MyCircleAvatar(avatarUrl: userModel.avatarUrl, radius: 30),
                    Utils.addHorizontalSpace(16),
                    Expanded(
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel.name,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Utils.addVerticalSpace(6),
                          Text(
                            getMessage(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )),
                    Text(
                      Utils.formatDate(widget
                              .conversationModel.lastMessage!.timeStamp ??
                          widget.conversationModel.lastMessage!.sentFromClient),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  String getMessage() =>
      (widget.conversationModel.lastMessage!.sentBy == currentUser.uid
          ? 'You: '
          : '') +
      widget.conversationModel.lastMessage!.message;
}
