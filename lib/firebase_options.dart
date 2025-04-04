// Import Firebase core to provide FirebaseOptions type
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Import platform detection utilities
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  // Returns the correct FirebaseOptions based on the current platform
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  // Firebase configuration for Web platform
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDQbkZn7ncs1iL2qH_nW-Y-vLbxXBq0-rE',
    appId: '1:69425150349:web:a5fcc981106bd4e902e5c4',
    messagingSenderId: '69425150349',
    projectId: 'hrn-flutter',
    authDomain: 'hrn-flutter.firebaseapp.com',
    storageBucket: 'hrn-flutter.firebasestorage.app',
    measurementId: 'G-PD2N9R626G',
  );

  // Firebase configuration for Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9WnkvWEVdSNbjgwEqTfL5HY-vTCnBrYQ',
    appId: '1:69425150349:android:f7492573767faffd02e5c4',
    messagingSenderId: '69425150349',
    projectId: 'hrn-flutter',
    storageBucket: 'hrn-flutter.firebasestorage.app',
  );

  // Firebase configuration for iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAo8pTig9vbKlDxjaZ2VtI8DTZniaIjxs',
    appId: '1:69425150349:ios:4da4f90e6c8a03fc02e5c4',
    messagingSenderId: '69425150349',
    projectId: 'hrn-flutter',
    storageBucket: 'hrn-flutter.firebasestorage.app',
    iosBundleId: 'com.example.finalProject',
  );

  // Firebase configuration for macOS (same as iOS in this case)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBAo8pTig9vbKlDxjaZ2VtI8DTZniaIjxs',
    appId: '1:69425150349:ios:4da4f90e6c8a03fc02e5c4',
    messagingSenderId: '69425150349',
    projectId: 'hrn-flutter',
    storageBucket: 'hrn-flutter.firebasestorage.app',
    iosBundleId: 'com.example.finalProject',
  );

  // Firebase configuration for Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQbkZn7ncs1iL2qH_nW-Y-vLbxXBq0-rE',
    appId: '1:69425150349:web:11c1cc8853335d6402e5c4',
    messagingSenderId: '69425150349',
    projectId: 'hrn-flutter',
    authDomain: 'hrn-flutter.firebaseapp.com',
    storageBucket: 'hrn-flutter.firebasestorage.app',
    measurementId: 'G-BJB23R9V12',
  );
}
