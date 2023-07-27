import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

//sender user message
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      // log('Updated content read');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.025
                : mq.width * 0.04),
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
            child: widget.message.type == Type.text
                ? Text(widget.message.msg,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      // width: mq.height * 0.45,
                      // height: mq.height * 0.35,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      imageUrl: widget.message.msg,
                      // placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.025),
          child: Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              )),
        ),
      ],
    );
  }

//personal user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 12, color: Colors.black54))
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.01
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * 0.01,
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.greenAccent),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )),
            child: widget.message.type == Type.text
                ? Text(widget.message.msg,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      // width: mq.height * 0.45,
                      // height: mq.height * 0.35,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      imageUrl: widget.message.msg,
                      // placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

//bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * 0.015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                height: 4,
              ),
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blueAccent, size: 28),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      },
                    )
                  : _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blueAccent, size: 28),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image URL: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: ' Messenger Test')
                              .then((success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Saved Successfully !!!');
                            }
                          });
                        } catch (e) {
                          log('Error while saving image: $e');
                        }
                      },
                    ),
              if (isMe)
                Divider(
                    color: Colors.black45,
                    endIndent: mq.width * .04,
                    indent: mq.width * .04),
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                  icon: const Icon(Icons.edit,
                      color: Colors.blueAccent, size: 28),
                  name: 'Edit Message',
                  onTap: () {
                    Navigator.pop(context);

                    _showMessageUpdateDialog();
                  },
                ),
              if (isMe)
                _OptionItem(
                  icon: const Icon(Icons.delete,
                      color: Colors.redAccent, size: 28),
                  name: 'Delete Message',
                  onTap: () {
                    APIs.deleteMessage(widget.message).then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
              Divider(
                  color: Colors.black45,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04),
              _OptionItem(
                icon:
                    const Icon(Icons.remove_red_eye, color: Colors.blueAccent),
                name:
                    'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                onTap: () {},
              ),
              _OptionItem(
                icon:
                    const Icon(Icons.remove_red_eye, color: Colors.greenAccent),
                name: widget.message.read.isEmpty
                    ? 'Read At: Message not seen yet'
                    : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                onTap: () {},
              ),
            ],
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Row(
                children: [
                  Icon(Icons.message_rounded,
                      color: Colors.blueAccent, size: 28),
                  Text('Update Message')
                ],
              ),
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    APIs.updateMessage(widget.message, updatedMsg);
                  },
                  child: const Text('Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                )
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * 0.015,
              bottom: mq.height * .025),
          child: Row(
            children: [
              icon,
              Flexible(
                  child: Text('   $name',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          letterSpacing: 0.5)))
            ],
          ),
        ));
  }
}
