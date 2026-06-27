import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError('Platform not supported');
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDslfZIi-KtHj4avPDoXCIHqGkIZsxmiaw',
    appId: '1:482966303898:android:ea65f6a9901b3e337d9b23',
    messagingSenderId: '482966303898',
    projectId: 'leoart-fb370',
    storageBucket: 'leoart-fb370.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6qL4S1eZ7h1iHiksADZ0dOqXWRb56f9k',
    appId: '1:482966303898:ios:ccf718a64494b6517d9b23',
    messagingSenderId: '482966303898',
    projectId: 'leoart-fb370',
    storageBucket: 'leoart-fb370.firebasestorage.app',
    iosClientId:
        '482966303898-ccf718a64494b6517d9b23.apps.googleusercontent.com',
    iosBundleId: 'com.leoart.admin',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB77_72NflwslMmHBLs9rzjM6WoJPU0Xm8',
    appId: '1:482966303898:web:558246f50b3c76a57d9b23',
    messagingSenderId: '482966303898',
    projectId: 'leoart-fb370',
    storageBucket: 'leoart-fb370.firebasestorage.app',
    authDomain: 'leoart-fb370.firebaseapp.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB77_72NflwslMmHBLs9rzjM6WoJPU0Xm8',
    appId: '1:482966303898:web:558246f50b3c76a57d9b23',
    messagingSenderId: '482966303898',
    projectId: 'leoart-fb370',
    storageBucket: 'leoart-fb370.firebasestorage.app',
    authDomain: 'leoart-fb370.firebaseapp.com',
  );
}
