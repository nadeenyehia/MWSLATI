import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mwslati3/Allscreens/loginScreen.dart';
import 'package:mwslati3/Allscreens/mainscreen.dart';
import 'package:mwslati3/Allscreens/registerationScreen.dart';
import 'package:mwslati3/splashscreen.dart';
import 'package:provider/provider.dart';

import 'DataHandler/appData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Mwslati',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ?SplashScreen.route:MainScreen.idScreen,
        routes: {
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          SplashScreen.route: (context) => SplashScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
