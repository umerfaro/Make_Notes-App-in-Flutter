import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/Color.dart';
import '../../resources/Components/Round_button.dart';
import '../../utils/utlis.dart';
import '../../view_models/Auth_View_Model.dart';
import 'Login_View.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _Emailcontroller = TextEditingController();
  final _auth=FirebaseAuth.instance;

  // after using above code we have to dispose the controller
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _Emailcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("built");
    final height = MediaQuery.sizeOf(context).height * 1;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<AuthModel>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0), // Add vertical spacing of 8.0 units
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        keyboardAppearance: Brightness.dark,
                        controller: _Emailcontroller,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "email@gmail.com",
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Consumer<AuthModel>(builder: (context, value, child) {
                  return RoundButton(
                    text: 'Forgot',
                    loading: value.getLoginPhoneloading,
                    onPressed: ()
                    {

                      if (_Emailcontroller.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            "Please Enter Email ID", context);
                      }
                      else {
                        value.LoginPhoneloadingchange(true);
                        Map data = {
                          "Email": _Emailcontroller.text.toString(),
                        };

                        ///that just reset the password
                        _auth.sendPasswordResetEmail(email: data["Email"]).then((values) {

                          value.LoginPhoneloadingchange(false);
                          Utils.toastMessage("Reset Link Send to your Email");
                        }).onError((error, stackTrace) {
                          value.LoginPhoneloadingchange(false);
                          Utils.flushBarErrorMessage(error.toString(), context);

                        });



                      }
                    },
                  );
                }),
                SizedBox(
                  height: height * 0.02,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                      //Navigator.pushNamed(context, RouteNames.login);
                    },
                    child:  Text("Login with Emial ID",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey[700]))),
              ],
            ),
          )),
    );
  }
}
