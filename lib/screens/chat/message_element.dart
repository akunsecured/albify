import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/message_model.dart';
import 'package:albify/themes/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageElement extends StatefulWidget {
  final MessageModel chatElement;

  MessageElement({required this.chatElement});

  @override
  _MessageElementState createState() => _MessageElementState();
}

class _MessageElementState extends State<MessageElement> {
  late User currentUser;
  late bool sender;

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sender = currentUser.uid != widget.chatElement.sentBy;
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 10, horizontal: MARGIN_HORIZONTAL),
      child: Align(
        alignment: sender ? Alignment.topLeft : Alignment.topRight,
        child: Column(
          crossAxisAlignment:
              sender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.2,
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: EdgeInsets.all(16),
              child: Text(widget.chatElement.message,
                  style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(RADIUS),
                      topRight: Radius.circular(RADIUS),
                      bottomLeft: sender
                          ? Radius.circular(SENDER_RADIUS)
                          : Radius.circular(RADIUS),
                      bottomRight: sender
                          ? Radius.circular(RADIUS)
                          : Radius.circular(SENDER_RADIUS)),
                  color:
                      sender ? Colors.grey.shade600 : AppStyle.appColorGreen),
            ),
            Align(
              alignment: sender ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Text(
                Utils.formatDate(widget.chatElement.timeStamp ??
                    widget.chatElement.sentFromClient),
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
