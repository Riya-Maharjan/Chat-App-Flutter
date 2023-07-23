import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: InkWell(
          onTap: () {
            //navigate to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list = data
                      ?.map(
                          (e) => Message.fromJson(convertToObjectMap(e.data())))
                      .toList() ??
                  [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.025),
                    child: CachedNetworkImage(
                      width: mq.height * 0.05,
                      height: mq.height * 0.05,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(
                  _message != null ? _message!.msg : widget.user.about,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ? Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(100)),
                          )
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black45)),
              );
            },
          )),
    );
  }

  Map<String, dynamic> convertToObjectMap(Object? data) {
    // First, check if the object is null or not an instance of Map
    if (data == null || data is! Map) {
      throw ArgumentError("Invalid input: data must be a non-null Map.");
    }

    // Cast the data to a Map<String, dynamic>
    Map<dynamic, dynamic> dynamicMap = data as Map<dynamic, dynamic>;

    // Convert keys and values to strings and dynamic respectively
    Map<String, dynamic> resultMap = {};
    dynamicMap.forEach((key, value) {
      resultMap[key.toString()] = value;
    });

    return resultMap;
  }
}
