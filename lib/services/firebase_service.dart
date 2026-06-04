// ============================================================
//  SmartParkify — FirebaseService
//  Firebase initialize karne ka central place
//  main.dart mein sirf yahi call karo
// ============================================================

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // FlutterFire CLI se generate hoga

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
