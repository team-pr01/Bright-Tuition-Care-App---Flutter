// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABASOUN41EdipMtEhCfONoOJaAnhdAQAE',
    appId: '1:1049754581614:android:a6647b7c161abab381c47f',
    messagingSenderId: '1049754581614',
    projectId: 'bright-tuition-care',
    storageBucket: 'bright-tuition-care.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABASOUN41EdipMtEhCfONoOJaAnhdAQAE',
    appId: '1:1049754581614:ios:YOUR_IOS_APP_ID', // ⚠️ You need to add iOS app in Firebase
    messagingSenderId: '1049754581614',
    projectId: 'bright-tuition-care',
    storageBucket: 'bright-tuition-care.firebasestorage.app',
    iosClientId: 'YOUR_IOS_CLIENT_ID', // ⚠️ Only if you have iOS app
    iosBundleId: 'com.prtechsolutions.btc.btcclient',
  );
}