import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Screen'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red[500],
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            icon: const Icon(Icons.logout_rounded),
            label: Text('Logout'),
          ),
        ),
        //dynamic and manages memory efficiently
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .04,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.1),
                child: CachedNetworkImage(
                  width: mq.height * 0.2,
                  height: mq.height * 0.2,
                  fit: BoxFit.fill,
                  imageUrl: widget.user.image,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(CupertinoIcons.person),
                ),
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              Text(widget.user.email,
                  style: const TextStyle(color: Colors.black87, fontSize: 16)),
              SizedBox(
                height: mq.height * .04,
              ),
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.blue[300]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'E.g. Riya Maharjan',
                    label: const Text('Username')),
              ),
              SizedBox(
                height: mq.height * .03,
              ),
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.info_outline, color: Colors.blue[300]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'E.g. I\'m on Messenger',
                    label: const Text('About')),
              ),
              SizedBox(
                height: mq.height * .03,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(mq.width, mq.height * 0.05)),
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
        ));
  }
}
