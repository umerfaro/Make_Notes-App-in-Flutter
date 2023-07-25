// import 'package:firebaseproject/view/postScreen/HomeScreen.dart';
// import 'package:firebaseproject/view/postScreen/add_post_screen.dart';
// import 'package:flutter/material.dart';
// import '../../view/auth/LogIN _with_Phone _Number.dart';
// import '../../view/auth/VerifyLogINCode.dart';
// import '../../view/auth/Login_View.dart';
// import '../../view/auth/SignUP.dart';
// import '../../view/splashScreen.dart';
// import 'Routes_name.dart';
//
// class Routes {
//   static Route<dynamic>generateRoutes(RouteSettings settings) {
//     switch (settings.name)
//     {
//       case RouteNames.homescreen:
//         {
//           return MaterialPageRoute(
//               builder: (BuildContext context) =>  MainHome());
//         }
//
//       case RouteNames.login:
//         {
//           return MaterialPageRoute(
//               builder: (BuildContext context) =>  LoginScreen());
//         }
//
//         case RouteNames.SignUp:
//         {
//           return MaterialPageRoute(
//               builder: (BuildContext context) => SignUPView());
//         }
//         case RouteNames.LoginINWithPhone:
//         {
//           return MaterialPageRoute(
//               builder: (BuildContext context) => LoginINWithPhone());
//         }
//         case RouteNames.LOginINhoneverification:
//         {
//           final arguments = settings.arguments as Map<String, dynamic>;
//           return MaterialPageRoute(
//               builder: (BuildContext context) => VerifyLogINCode(
//                 VerificationId: arguments['VerificationId'],
//                 Phonenumber: arguments['Phonenumber'],
//
//               ));
//         }
//         case RouteNames.splash:
//         {
//           return MaterialPageRoute(
//               builder: (BuildContext context) => const Splashscreen());
//         }
//       case RouteNames.AddPostScreen:
//         return MaterialPageRoute(
//           builder: (BuildContext context) => AddPostScreen(), // Replace YourAddPostScreenWidget with the actual widget you want to navigate to.
//         );
//
//       default:
//         {
//           return MaterialPageRoute(builder: (_) {
//             return Scaffold(
//               body: Center(
//                 child: Text('No route defined for ${settings.name}'),
//               ),
//             );
//           });
//         }
//     }
//   }
// }
