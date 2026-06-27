import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Platform not supported');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('Platform not supported');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDslfZIi-KtHj4avPDoXCIHqGkIZsxmiaw',
    appId: '1:482966303898:android:15e1dfa5cec70f837d9b23',
    messagingSenderId: '482966303898',
    projectId: 'leoart-fb370',
    storageBucket: 'leoart-fb370.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6qL4S1eZ7h1iHiksADZ0dOqXWRb56f9k',
    appId: '1:482966303898:ios:ba8bcf784f9f06f67d9b23',
    messagingSenderId: '482966303898',
    projectId: 'leoart-fb370',
    storageBucket: 'leoart-fb370.firebasestorage.app',
    iosClientId:
        '482966303898-ba8bcf784f9f06f67d9b23.apps.googleusercontent.com',
    iosBundleId: 'com.leoart.app',
  );
}
