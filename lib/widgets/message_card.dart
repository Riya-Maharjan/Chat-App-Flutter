import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

//sender user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * 0.01,
            ),
            decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.lightBlue),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: Text(
                widget.message.msg +
                    'Random messageRandom messageRandom messageRandom messageRandom messageRandom message',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.4),
          child: Text(widget.message.sent,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              )),
        ),
      ],
    );
  }

//personal user message
  Widget _greenMessage() {
    return Container();
  }
}
