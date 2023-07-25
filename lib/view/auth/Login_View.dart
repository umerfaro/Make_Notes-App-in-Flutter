import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../resources/Color.dart';
import '../../resources/Components/Round_button.dart';
import '../../resources/Components/SquareTile.dart';
import '../../utils/routes/Routes_name.dart';
import '../../utils/utlis.dart';
import '../../view_models/Auth_View_Model.dart';
import '../../view_models/GoogleAuthServices.dart';
import 'Forgot_password.dart';
import 'LogIN _with_Phone _Number.dart';
import 'SignUP.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  FocusNode namefocus = FocusNode();
  FocusNode passwordfocus = FocusNode();

  // after using above code we have to dispose the controller
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    namefocus.dispose();
    passwordfocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // final authViewModel = Provider.of<AuthViewModel>(context);

    final height = MediaQuery.sizeOf(context).height * 1;
    print("built");
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height * 0.1,
                          width: height * 0.1,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/lock.png"))),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text('Welcom back you\'ve been missed',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[700])),

                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextField(
                        onSubmitted: (val) {
                          Utils.FieldFocusChange(context, namefocus, passwordfocus);
                        },
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        controller: _namecontroller,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 16.0), // Add space after the icon
                            child: Icon(Icons.email_outlined, color: Colors.grey[700]),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Enter your Email",
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.02,
                      ),
                      Consumer<AuthModel>(builder: (context, value, child)
                      {
                        return TextField(

                          focusNode: passwordfocus,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordcontroller,
                          obscureText: value.gettoogle,
                          decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 16.0), // Add space after the icon
                                child: Icon(Icons.lock, color: Colors.grey[700]),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),

                              ),
                              hintText: "Enter your password",
                              suffix: InkWell(
                                  onTap: () {
                                    value.changetoogle();
                                  },
                                  child: Icon(value.gettoogle
                                      ? Icons.visibility_off_outlined
                                      : Icons.remove_red_eye))),
                        );
                      }),

                      SizedBox(
                        height: height * 0.00001,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                              //Navigator.pushNamed(context, RouteNames.SignUp);
                            },
                            child: Text("Forgot Password?",style: TextStyle(color: Colors.grey[700]),)),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Consumer<AuthModel>(builder: (context, value, child) {

                        return RoundButton(
                          text: 'Login',
                          loading: value.getisloading,
                          onPressed: () {
                            if (_namecontroller.text.isEmpty) {
                              Utils.flushBarErrorMessage(
                                  "Please Enter Username", context);
                            } else if (_passwordcontroller.text.isEmpty) {
                              Utils.flushBarErrorMessage(
                                  "Please Enter password", context);
                            } else if (_passwordcontroller.text.length < 6) {
                              Utils.flushBarErrorMessage(
                                  "Please Enter 6 digit password", context);
                            } else {
                              Map data = {
                                "email": _namecontroller.text.toString(),
                                "password": _passwordcontroller.text.toString()
                              };
                              value.isLogin(data, context);

                            }
                          },
                        );
                      }),
                      SizedBox(
                        height: height * 0.02,
                      ),

                      Container(
                        height: 40,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginINWithPhone()));
                            //  Navigator.pushNamed(context, RouteNames.LoginINWithPhone);
                            },
                            child: Text("Login with Phone number",style: TextStyle(color: Colors.grey[700]))),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                     Row(
                       children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[700],
                              thickness: 0.5,
                            ),
                          ),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 10),
                           child: Text("Or continue With",style: TextStyle(color: Colors.grey[700]),),
                         ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[700],
                              thickness: 0.5,
                            ),
                          ),
                       ],
                     ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(imagePath: 'images/google.png', onTap: () {
                            GoogleAuthServices().signInWithGoogle(context).then((value) {
                              Utils.toastMessage("Login Successfully");
                            });

                          },),
                          SizedBox(
                            width: 25,
                          ),
                          SquareTile(imagePath: 'images/facebook.png', onTap: () {
                          },),

                        ],

                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",style: TextStyle(color: Colors.grey[700])),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUPView()));
                                //Navigator.pushNamed(context, RouteNames.SignUp);
                              },
                              child: Text("Register",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF4da5ff,)),))
                        ],
                      ),




                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
