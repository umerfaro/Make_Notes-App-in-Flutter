
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../FireStore/FireStore_List_Screen.dart';
import '../utils/utlis.dart';
import '../view/auth/VerifyLogINCode.dart';

class AuthModel with ChangeNotifier {
  //initializing the firebase
  final _auth = FirebaseAuth.instance;

  bool _isloading = false;
  get getisloading => _isloading;

  void changeisloading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  bool _isverificationloading = false;
  get getisverificationloading => _isverificationloading;

  void changeverificationisloading(bool value) {
    _isverificationloading = value;
    notifyListeners();
  }

  bool _signuploading = false;
  get getsignuploading => _signuploading;

  void Signuploadingchnage(bool value) {
    _signuploading = value;
    notifyListeners();
  }

  bool _LoginPhoneloading = false;
  get getLoginPhoneloading => _LoginPhoneloading;

  void LoginPhoneloadingchange(bool value) {
    _LoginPhoneloading = value;
    notifyListeners();
  }

  void LoginWithPhoneNumber(data, BuildContext context) {
    LoginPhoneloadingchange(true);
    _auth.verifyPhoneNumber(
        phoneNumber: data["phone"],
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          LoginPhoneloadingchange(false);
          Utils.flushBarErrorMessage(e.toString(), context);
        },
        codeSent: (String verificationId, int? token) {
          LoginPhoneloadingchange(false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyLogINCode(
                        VerificationId: verificationId,
                        Phonenumber: data["phone"].toString(),
                      )));
        },
        codeAutoRetrievalTimeout: (e) {
          LoginPhoneloadingchange(false);
          Utils.toastMessage(e.toString());
        });
  }

  void VerifyWithPhoneNUmber(data) async {
    changeverificationisloading(true);
    final credential = PhoneAuthProvider.credential(
      verificationId: data["VerificationId"],
      smsCode: data["code"],
    );
    try {
      await _auth.signInWithCredential(credential);
      changeverificationisloading(false);
      Utils.toastMessage("Login Successfully");
      // Instead of using Navigator.pushNamed, you can use Navigator.of(context).pushNamed
      Navigator.push(
          data['context'], MaterialPageRoute(builder: (context) => FireStoreListScreen()));
      //Navigator.pushNamed(data['context'], RouteNames.homescreen);
    } catch (e) {
      changeverificationisloading(false);
      print(e.toString());
      Utils.flushBarErrorMessage(e.toString(), data["context"]);
    }
  }

  void isSignUP(data, BuildContext context) {
    Signuploadingchnage(true);
    _auth
        .createUserWithEmailAndPassword(
            email: data["email"], password: data["password"])
        .then((value) {
      Signuploadingchnage(false);
      Utils.toastMessage("Register Successfully");
    }).onError((error, stackTrace) {
      Signuploadingchnage(false);
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }

  void isLogin(data, BuildContext context) {
    changeisloading(true);
    _auth
        .signInWithEmailAndPassword(
            email: data["email"], password: data["password"])
        .then((value) {
      changeisloading(false);
      Utils.toastMessage("Login Successfully");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FireStoreListScreen()));
      // Navigator.pushNamed(context, RouteNames.homescreen);
    }).onError((error, stackTrace) {
      changeisloading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }

  bool _toogle = true;
  get gettoogle => _toogle;

  void changetoogle() {
    _toogle = !_toogle;
    notifyListeners();
  }

  String countrycode = "92";
  String get getcountrycode => countrycode;

  void changecountrycode(String value) {
    countrycode = value;
    notifyListeners();
  }

  String _changeSearch = "";
  String get getChangeSearch => _changeSearch;

  void changeSearchState(String value) {
    _changeSearch = value;
    notifyListeners();
  }

  final databaseReference = FirebaseDatabase.instance.ref('Post');

  bool _addloading = false;
  get getaddloading => _addloading;

  void AddDataloadingchnage(bool value) {
    _addloading = value;
    notifyListeners();
  }

  void AddDataINtoDataBase(
      String title, String descrption, BuildContext context) {
    String id= DateTime.now().microsecondsSinceEpoch.toString();
    AddDataloadingchnage(true);
    databaseReference
        .child(id)
        .set({
          'title': title,
          'Id': id,
          'description': descrption,
        })
        .then((value) => {
              AddDataloadingchnage(false),
              Utils.toastMessage("Data Added Successfully"),
              Navigator.pop(context)
            })
        .onError((error, stackTrace) => {
              AddDataloadingchnage(false),
              Utils.flushBarErrorMessage(error.toString(), context)
            });
  }


  String? getCurrentUser() {
    return _auth.currentUser?.uid;
  }

  ////////////////////////////////////////////////////////////
  // final fireStore= FirebaseFirestore.instance.collection('users');
  // void AddDataINtoFireStoreDataBase(String title, String descrption, BuildContext context) {
  //
  //   AddDataloadingchnage(true);
  //   String id =DateTime.now().microsecondsSinceEpoch.toString();
  //   fireStore.doc(id).set({
  //     'title': title,
  //     'Id': id,
  //     'description': descrption,
  //
  //
  //   }).then((value) {
  //     AddDataloadingchnage(false);
  //     Utils.toastMessage("Data Added Successfully");
  //     Navigator.pop(context);
  //
  //   }).onError((error, stackTrace) {
  //     AddDataloadingchnage(false);
  //     Utils.flushBarErrorMessage(error.toString(), context);
  //   });
  //
  //
  // }
}
//////////////////////////////////////////////////////////////

// class AuthModel with ChangeNotifier{
//
//   String _ChangeSearch = "";
//   String get getChangeSearch => _ChangeSearch;
//
//   void ChnagesearchState(String value)
//   {
//     _ChangeSearch = value;
//     notifyListeners();
//   }
//
// }
