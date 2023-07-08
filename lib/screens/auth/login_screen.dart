import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  _handleGoogleButtonClick() {
    //display progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //hide progress bar
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUser Additional Information: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, 'Something went wrong. Check your Internet connection');
      return null;
    }
  }

  // _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Welcome to Messenger App'),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              top: mq.height * .15,
              width: mq.width * .5,
              right: _isAnimated ? mq.width * .25 : -mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/icon.png'),
            ),
            Positioned(
              bottom: mq.height * .15,
              width: mq.width * .9,
              left: mq.width * .05,
              height: mq.height * 0.06,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent[100],
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                onPressed: () {
                  _handleGoogleButtonClick();
                },
                icon:
                    Image.asset('images/google.png', height: mq.height * 0.04),
                // icon: Icon(Icons.),
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(text: 'Sign In with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                ),
              ),
            ),
          ],
        ));
  }
}
