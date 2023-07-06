// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA_mEuVFAwXd8OYkpWrzbYsSxz8XvuBmJ8',
    appId: '1:367933160214:web:9515ad7464044f5085ae37',
    messagingSenderId: '367933160214',
    projectId: 'messenger-1c5b3',
    authDomain: 'messenger-1c5b3.firebaseapp.com',
    storageBucket: 'messenger-1c5b3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfG1ueR9kNH5t3Ck4HSu_LMijR-bl7OEg',
    appId: '1:367933160214:android:d340c4e79a75dd7b85ae37',
    messagingSenderId: '367933160214',
    projectId: 'messenger-1c5b3',
    storageBucket: 'messenger-1c5b3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDBfDgS2Q3ptN6QTUzbEaGuShs0dovqss',
    appId: '1:367933160214:ios:2ad053bc546a55f185ae37',
    messagingSenderId: '367933160214',
    projectId: 'messenger-1c5b3',
    storageBucket: 'messenger-1c5b3.appspot.com',
    androidClientId: '367933160214-0f5n7npnr2gli75hf7otguj2fjcd15pq.apps.googleusercontent.com',
    iosClientId: '367933160214-t49463f6mmm1ja3ag69c7j94dobpu1c2.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
