import 'package:firebaseproject/utils/routes/Routes.dart';
import 'package:firebaseproject/utils/routes/Routes_name.dart';
import 'package:firebaseproject/view/splashScreen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'view_models/Auth_View_Model.dart';


Future main() async {
  await Future.delayed(const Duration(seconds: 10));
  FlutterNativeSplash.remove();

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
    {
      await Firebase.initializeApp(
     options: const FirebaseOptions(
         apiKey: "AIzaSyAsbictGfEvadAB5Ai725Zl24EaFt0E0ME",
         authDomain: "dummy-e9d94.firebaseapp.com",
         databaseURL: "https://dummy-e9d94-default-rtdb.firebaseio.com",
         projectId: "dummy-e9d94",
         storageBucket: "dummy-e9d94.appspot.com",
         messagingSenderId: "196256863831",
         appId: "1:196256863831:web:72379e86e7aab298227512",
         measurementId: "G-FEJ3C2CB5D"

     ));
    }
  else{
    await Firebase.initializeApp(
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> AuthModel()),
        ],

        child: Builder(builder: (BuildContext context){

          return MaterialApp(

            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const Splashscreen(),
            // initialRoute: RouteNames.splash,
            // onGenerateRoute: Routes.generateRoutes,
          );
        })

    );
  }
}


