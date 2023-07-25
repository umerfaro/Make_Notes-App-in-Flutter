import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../FireStore/FireStore_List_Screen.dart';

class GoogleAuthServices {
  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    // Begin the sign-in process with interactive style
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase sign in with credential
      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the home screen after successful sign-in
      if (authResult.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreListScreen())).then((value) {
          Utils.toastMessage("Login Successfully");
        }).onError((error, stackTrace) {
          Utils.flushBarErrorMessage(error.toString(),context);
        }); // Replace the current route with the home screen
      }
    }
  }
}
