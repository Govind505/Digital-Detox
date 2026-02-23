import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'REPLACE_WITH_FIREBASE_API_KEY',
        appId: '1:000000000000:android:placeholder',
        messagingSenderId: '000000000000',
        projectId: 'digital-detox-coach',
        storageBucket: 'digital-detox-coach.appspot.com',
      );
}
