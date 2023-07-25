import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              Positioned(
                top: mq.height * 0.75,
                left: mq.width * 0.1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: CachedNetworkImage(
                    width: mq.height * 0.2,
                    height: mq.height * 0.2,
                    fit: BoxFit.fill,
                    imageUrl: user.image,
                    // placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              Positioned(
                left: mq.width * .04,
                top: mq.height * .02,
                width: mq.width * 0.55,
                child: Text(
                  user.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                right: 8,
                top: 4,
                child: MaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                    minWidth: 0,
                    padding: EdgeInsets.all(0),
                    child: const Icon(
                      Icons.info_outline,
                      size: 30,
                      color: Colors.blueAccent,
                    )),
              )
            ],
          )),
    );
  }
}
