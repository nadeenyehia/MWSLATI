import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mwslati3/AllWidgets/progressDialog.dart';
import 'package:mwslati3/Allscreens/mainscreen.dart';
import 'package:mwslati3/Allscreens/registerationScreen.dart';
import 'package:mwslati3/main.dart';
import 'package:mwslati3/sharedPreferences.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "Login";
  TextEditingController emailTextEditingContoller = TextEditingController();
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
                height: 35.0,
              ),

              SizedBox(
                height: 200.0,
              ),
              Text(
                "Login as a rider",
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
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if (!emailTextEditingContoller.text.contains("@")) {
                          displayToastMessage(
                              "Email address is not valid.", context);
                        } else if (passwordTextEditingContoller.text.isEmpty) {
                          displayToastMessage(
                              "password is mandatory.", context);
                        } else {
                          loginAndAuthenticationUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have an account? Register Here.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticationUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return progressDialog(
            message: "Authenticating,please wait...",
          );
        });
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingContoller.text,
                password: passwordTextEditingContoller.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //save user info to data base
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          MySharedPreferences.saveUserSingIn(true);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are logged-in now.", context);
        } else {
          Navigator.pop(context);

          _firebaseAuth.signOut();
          displayToastMessage(
              "No record exists for this user.please create new account.",
              context);
        }
      });
    } else {
      Navigator.pop(context);

      //error occured-display error msg
      displayToastMessage("Error Occured, can not build.", context);
    }
  }
}
