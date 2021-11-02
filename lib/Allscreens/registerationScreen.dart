import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mwslati3/AllWidgets/progressDialog.dart';
import 'package:mwslati3/Allscreens/loginScreen.dart';
import 'package:mwslati3/Allscreens/mainscreen.dart';
import 'package:mwslati3/main.dart';

import '../sharedPreferences.dart';

class RegisterationScreen extends StatelessWidget {
  static const String idScreen = "Register";
  TextEditingController nameTextEditingContoller = TextEditingController();
  TextEditingController emailTextEditingContoller = TextEditingController();
  TextEditingController phoneTextEditingContoller = TextEditingController();
  TextEditingController passwordTextEditingContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 180.0,
              ),
              Text(
                "Register as a rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextEditingContoller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingContoller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingContoller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingContoller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if (nameTextEditingContoller.text.length < 3) {
                          displayToastMessage(
                              "name must be atleast 3 characters.", context);
                        } else if (!emailTextEditingContoller.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not valid.", context);
                        } else if (phoneTextEditingContoller.text.isEmpty) {
                          displayToastMessage(
                              "phone Number is mandatory.", context);
                        } else if (passwordTextEditingContoller.text.length <
                            6) {
                          displayToastMessage(
                              "password must be at least 6 characters.",
                              context);
                        } else {
                          registrNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an account? Login Here.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registrNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return progressDialog(
            message: "Regisreing,please wait...",
          );
        });
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingContoller.text,
                password: passwordTextEditingContoller.text)
            .catchError((errMsg) {
      Navigator.pop(context);

      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //save user info to data base
      Map userDataMap = {
        "name": nameTextEditingContoller.text.trim(),
        "email": emailTextEditingContoller.text.trim(),
        "phone": phoneTextEditingContoller.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("your account has been created.", context);
      MySharedPreferences.saveUserSingIn(true);

      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);

      //error occured-display error msg
      displayToastMessage("New user account has not been created.", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
