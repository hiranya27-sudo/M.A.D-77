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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDa0TaNWPhWMrwwd0bnhQSwGuJciGQ4NJA',
    appId: '1:826525075997:web:be67470520ecf2973694f4',
    messagingSenderId: '826525075997',
    projectId: 'chefmind-fc748',
    authDomain: 'chefmind-fc748.firebaseapp.com',
    storageBucket: 'chefmind-fc748.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsod4dtvS46Iv2A9UslgNf5pFV440mrRo',
    appId: '1:826525075997:android:dafbf8dcab6d09a13694f4',
    messagingSenderId: '826525075997',
    projectId: 'chefmind-fc748',
    storageBucket: 'chefmind-fc748.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8K4PqFoSyUuYv-Uv0WSjkMOWsOXS9Yi8',
    appId: '1:826525075997:ios:0b4234f8b07ee94f3694f4',
    messagingSenderId: '826525075997',
    projectId: 'chefmind-fc748',
    storageBucket: 'chefmind-fc748.firebasestorage.app',
    iosBundleId: 'com.example.chefmind',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8K4PqFoSyUuYv-Uv0WSjkMOWsOXS9Yi8',
    appId: '1:826525075997:ios:0b4234f8b07ee94f3694f4',
    messagingSenderId: '826525075997',
    projectId: 'chefmind-fc748',
    storageBucket: 'chefmind-fc748.firebasestorage.app',
    iosBundleId: 'com.example.chefmind',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDa0TaNWPhWMrwwd0bnhQSwGuJciGQ4NJA',
    appId: '1:826525075997:web:982d610133b57b2f3694f4',
    messagingSenderId: '826525075997',
    projectId: 'chefmind-fc748',
    authDomain: 'chefmind-fc748.firebaseapp.com',
    storageBucket: 'chefmind-fc748.firebasestorage.app',
  );
}
