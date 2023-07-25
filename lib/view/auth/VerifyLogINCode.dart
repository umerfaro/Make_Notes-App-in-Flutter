import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../resources/Components/Round_button.dart';
import '../../utils/utlis.dart';
import '../../view_models/Auth_View_Model.dart';


class VerifyLogINCode extends StatefulWidget {
  final String VerificationId;
  final String Phonenumber;
  const VerifyLogINCode(
      {super.key,  required this.VerificationId, required this.Phonenumber});

  @override
  State<VerifyLogINCode> createState() => _VerifyLogINCodeState();
}

class _VerifyLogINCodeState extends State<VerifyLogINCode> {

  TextEditingController _phoneController = TextEditingController();

  @override
  void  dispose()
  {
    super.dispose();
    _phoneController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print('biult ');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Verification Code ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ' we\'ve sent it to ' + widget.Phonenumber,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PinCodeTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 50,
                            fieldWidth: 45, // Adjust the width for 6-digit code
                            activeFillColor: Colors.black,
                            inactiveFillColor: Colors.black,
                            selectedFillColor: Colors.black,
                            activeColor: Colors.black,
                            inactiveColor: Colors.black,
                            selectedColor: Colors.black,
                            borderWidth: 1,
                          ),
                          appContext: context,
                          length: 6, // Set the length to 6 for a 6-digit code
                          onChanged: (value) {
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(height: 100),
                Center(child:
                Consumer<AuthModel>(builder: (context, value, child) {
                  return RoundButton(
                    text: 'Submit',
                    loading: value.getisverificationloading,
                    onPressed: () async {
                      if (_phoneController.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            "Please Enter Code first", context);
                      } else {
                        Map<String, dynamic> data = {
                          "code": _phoneController.text.toString(),
                          "VerificationId": widget.VerificationId,
                          "context": context, // Add the context to the data map
                        };
                        value.VerifyWithPhoneNUmber(data);
                      }
                    },
                  );
                })
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Didn\'t get the code?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,

                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Retrieve the code over the Call ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          ),
                    ),
                  ],
                )
              ],
            )),
          ),
        ));
  }
}
