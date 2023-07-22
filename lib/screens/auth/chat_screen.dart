import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../main.dart';
import '../../models/chat_user.dart';
import '../../models/message.dart';
import '../../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      //if some or all data is loaded then display
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        log('Data: ${jsonEncode(data![0].data())}');
                        _list.clear();
                        _list.add(Message(
                            toId: 'person1',
                            msg: 'Hi',
                            read: '',
                            type: Type.text,
                            fromId: APIs.user.uid,
                            sent: '12:00 AM'));
                        _list.add(Message(
                            toId: APIs.user.uid,
                            msg: 'Hello',
                            read: '',
                            type: Type.text,
                            fromId: 'person1',
                            sent: '12:05 AM'));
                        // _list = data ?.map((e) => ChatUser.fromJson(e.data()))
                        //         .toList() ??
                        //     [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * 0.02),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              });
                        } else {
                          return const Center(
                              child: Text(
                            'Start Conversation 😊',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ));
                        }
                    }
                  }),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black54)),
          ClipRRect(
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
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 5),
              const Text('Last Seen text',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                      )),
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type message',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera,
                        color: Colors.blueAccent,
                      )),
                  SizedBox(
                    width: mq.width * 0.02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
              onPressed: () {},
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 5, left: 10),
              minWidth: 0,
              shape: const CircleBorder(),
              color: Colors.blueAccent,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 26,
              ))
        ],
      ),
    );
  }
}
