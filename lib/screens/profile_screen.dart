import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile Screen'),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red[500],
              onPressed: () async {
                Dialogs.showProgressBar(context);
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //hiding progress dialog
                    Navigator.pop(context);
                    //moving to home screen
                    Navigator.pop(context);
                    //replacing home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text('Logout'),
            ),
          ),
          //dynamic and manages memory efficiently
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .04,
                    ),
                    Stack(
                      children: [
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                              onPressed: () {},
                              color: Colors.white,
                              shape: const CircleBorder(),
                              child: Icon(Icons.edit, color: Colors.blue[300])),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .04,
                    ),
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16)),
                    SizedBox(
                      height: mq.height * .04,
                    ),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (value) => APIs.me.name = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.person, color: Colors.blue[300]),
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
                      onSaved: (value) => APIs.me.about = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Required Field',
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully!');
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'Update',
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
