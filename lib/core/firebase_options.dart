import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoCPBjHnRCRslAc4Xrew69oR_UfrhohuI',
    appId: '1:939137705676:android:4b2caf32197326a1ee8469',
    messagingSenderId: '939137705676',
    projectId: 'fypapp-b8eb2',
    storageBucket: 'fypapp-b8eb2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoCPBjHnRCRslAc4Xrew69oR_UfrhohuI',
    appId: '1:939137705676:android:4b2caf32197326a1ee8469',
    messagingSenderId: '939137705676',
    projectId: 'fypapp-b8eb2',
    storageBucket: 'fypapp-b8eb2.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCoCPBjHnRCRslAc4Xrew69oR_UfrhohuI',
    appId: '1:939137705676:android:4b2caf32197326a1ee8469',
    messagingSenderId: '939137705676',
    projectId: 'fypapp-b8eb2',
    storageBucket: 'fypapp-b8eb2.firebasestorage.app',
  );
}
