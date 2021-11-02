import 'package:flutter/material.dart';
import 'package:mwslati3/Allscreens/loginScreen.dart';
import 'package:mwslati3/Allscreens/mainscreen.dart';
import 'package:mwslati3/Models/users.dart';

import '../sharedPreferences.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  getUserData() async {
    Users.userlogIn = await MySharedPreferences.getUserSingIn() ?? false;
    Users.userAdders = await MySharedPreferences.getUserAddress();
    Users.userLat = await MySharedPreferences.getUserLat();
    Users.userLong = await MySharedPreferences.getUserlong();
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (Users.userlogIn == false) {
      return LoginScreen();
    } else {
      return MainScreen();
    }
  }
}
