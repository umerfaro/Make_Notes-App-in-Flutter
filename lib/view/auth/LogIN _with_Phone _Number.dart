

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/Color.dart';
import '../../resources/Components/Round_button.dart';
import '../../resources/Components/SquareTile.dart';
import '../../utils/routes/Routes_name.dart';
import '../../utils/utlis.dart';
import '../../view_models/Auth_View_Model.dart';
import 'package:country_picker/country_picker.dart';

import '../../view_models/GoogleAuthServices.dart';
import 'Login_View.dart';
import 'SignUP.dart';
class LoginINWithPhone extends StatefulWidget {
  const LoginINWithPhone({super.key});

  @override
  State<LoginINWithPhone> createState() => _LoginINWithPhoneState();
}

class _LoginINWithPhoneState extends State<LoginINWithPhone> {

  TextEditingController _Phonecontroller = TextEditingController();



  // after using above code we have to dispose the controller
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _Phonecontroller.dispose();
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
                              image: AssetImage("images/phone-call.png"))),
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
                  Consumer<AuthModel>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0), // Add vertical spacing of 8.0 units
                        child: TextField(
                          keyboardType: TextInputType.number,
                          keyboardAppearance: Brightness.dark,
                          controller: _Phonecontroller,
                          decoration: InputDecoration(
                            labelText: "Phone number",
                            prefixStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            prefix: InkWell(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  favorite: ['+92', 'PK'],
                                  onSelect: (Country country) {
                                    value.changecountrycode(country.phoneCode.toString());
                                  },
                                );
                              },
                              child: Text('+${value.getcountrycode.toString()} '),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "1234567890",
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
                      text: 'Login',
                      loading: value.getLoginPhoneloading,
                      onPressed: () {
                        if (_Phonecontroller.text.isEmpty) {
                          Utils.flushBarErrorMessage(
                              "Please Enter Phone Number", context);
                        } else {

                          String phoneNumber = '+${value.getcountrycode.toString()}'+_Phonecontroller.text.toString();
                          Map data = {
                            "phone": phoneNumber.toString(),
                          };
                          value.LoginWithPhoneNumber(data, context);
                        }
                      },
                    );
                  }),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUPView()));
                            //Navigator.pushNamed(context, RouteNames.SignUp);
                          },
                          child: Text("Register",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF4da5ff,)),))
                    ],
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
                      SquareTile(imagePath: 'images/facebook.png', onTap: () {  },),

                    ],

                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        //Navigator.pushNamed(context, RouteNames.login);
                      },
                      child: Text("Login with Emial ID",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),))
                ],

              ),
            ),
          )),
    );
  }
}
