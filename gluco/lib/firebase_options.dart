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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA3RfAq2UFQLnxp_MukU5AWNlfFv1VgdGw',
    appId: '1:506625053641:web:e7f364b69e43ff4d99ce18',
    messagingSenderId: '506625053641',
    projectId: 'egluco',
    authDomain: 'egluco.firebaseapp.com',
    storageBucket: 'egluco.appspot.com',
    measurementId: 'G-ELPF3B5RSX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAviavEOAHgTbE8DyeuJSnOXbeqIJBhLlM',
    appId: '1:506625053641:android:2da757ba669d59d099ce18',
    messagingSenderId: '506625053641',
    projectId: 'egluco',
    storageBucket: 'egluco.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2gh_reDI87fwjI53RC95zmFKYqAgrAGU',
    appId: '1:506625053641:ios:950be0666a5de10f99ce18',
    messagingSenderId: '506625053641',
    projectId: 'egluco',
    storageBucket: 'egluco.appspot.com',
    iosClientId: '506625053641-p1b8g7rrocje229tagg1oatlc8m3p9vp.apps.googleusercontent.com',
    iosBundleId: 'com.example.gluco',
  );
}