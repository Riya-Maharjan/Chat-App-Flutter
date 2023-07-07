import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_user.dart';

class APIs {
  //authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //access cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static get user => auth.currentUser!;

  //user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //create new user
  static Future<bool> createUser() async {
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString());

    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }
}
