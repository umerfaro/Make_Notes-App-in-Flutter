
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../FireStore/FireStore_List_Screen.dart';
import '../utils/routes/Routes_name.dart';
import '../view/auth/Login_View.dart';
import '../view/postScreen/HomeScreen.dart';

class splashScreens{

  void IsSplashLogin(BuildContext context)
  {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null)
    {
      Timer(const Duration(seconds: 3),
              //()=>   Navigator.push(context, MaterialPageRoute(builder: (context)=>MainHome()))
              ()=>   Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreListScreen()))
                  //Navigator.pushNamed(context, RouteNames.homescreen)
      );
    }
    else {
      Timer(const Duration(seconds: 3),
              ()=>  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()))
                  //Navigator.pushNamed(context, RouteNames.login)
      );
    }


  }


}