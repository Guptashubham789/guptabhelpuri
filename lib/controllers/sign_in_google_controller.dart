import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

Future<UserCredential?> signInWithGoogle() async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  if (kIsWeb) {
    // WEB LOGIN
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    // Optional: force account selection
    authProvider.setCustomParameters({
      'prompt': 'select_account',
    });

    try {
      // Popup method (recommended for web)
      return await auth.signInWithPopup(authProvider);
    } catch (e) {
      print("Web Sign-In Error: $e");
      return null;
    }

  } else {
    // MOBILE LOGIN
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser =
    await googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await auth.signInWithCredential(credential);
  }
}