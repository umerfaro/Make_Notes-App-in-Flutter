
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../FireStore/FireStore_List_Screen.dart';
import '../utils/utlis.dart';

class FacebookAuthServices {
  // Sign in with Facebook
  Future<void> signInWithFacebook(BuildContext context) async {
    // Log in with Facebook
    final LoginResult result = await FacebookAuth.instance.login();

    // Check if login was successful
    if (result.status == LoginStatus.success) {
      // Obtain the access token
      final AccessToken accessToken = result.accessToken!;
      final String accessTokenString = accessToken.token;

      // Create a new credential
      final OAuthCredential credential = FacebookAuthProvider.credential(accessTokenString);

      // Firebase sign in with credential
      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the home screen after successful sign-in
      if (authResult.user != null) {

        Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreListScreen())).then((value) {
          Utils.toastMessage("Login Successfully");
        }).onError((error, stackTrace) {
          Utils.flushBarErrorMessage(error.toString(),context);
        });
      }
    }
  }
}
