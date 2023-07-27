import 'dart:developer';

import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'firebase_options.dart';

// import 'screens/home_screen.dart';
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Messenger',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          backgroundColor: Colors.white,
        )),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const SplashScreen());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Show Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: "Chats",
  );
  log(result);
}
