import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        apiKey: '',
        authDomain: '',
        databaseURL: '',
        projectId: '',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        messagingSenderId: '',
        appId: '',
        measurementId: '',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        iosBundleId: '',
        iosClientId: '',
        databaseURL: '',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '',
        apiKey: '',
        projectId: '',
        messagingSenderId: '',
        authDomain: '',
        androidClientId: '',
      );
    }
  }
}
