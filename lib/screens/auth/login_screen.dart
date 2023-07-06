import 'package:flutter/material.dart';

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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
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
