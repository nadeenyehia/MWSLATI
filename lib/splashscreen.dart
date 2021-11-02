import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mwslati3/DataHandler/appData.dart';
import 'package:mwslati3/Models/users.dart';
import 'package:mwslati3/getuserAddress.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';
import 'package:mwslati3/sharedPreferences.dart';

class SplashScreen extends StatefulWidget {
  static final route = '/splashScreen';

  static bool slider = true;
  static void isSlider() {
    slider = !slider;
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getUserData() async {
    Users.userlogIn = await MySharedPreferences.getUserSingIn() ?? false;
    Users.userAdders = await MySharedPreferences.getUserAddress();
    Users.userLat = await MySharedPreferences.getUserLat();
    Users.userLong = await MySharedPreferences.getUserlong();
  }

  // String? _currentAddress;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentLocation(context);
    Timer(
      Duration(seconds: 10),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Authenticate(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/logo.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  // _getCurrentLocation() async {
  //   try {
  //     final geoposition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       MySharedPreferences.saveUserlong('${geoposition.longitude}');
  //       MySharedPreferences.saveUserlat('${geoposition.latitude}');
  //     });
  //     _getAddressFromLatLng(geoposition);
  //   } catch (e) {
  //     print('geoposition Erorr:' + e.toString());
  //   }
  // }

  // _getAddressFromLatLng(final geoposition) async {
  //   print(geoposition);
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         geoposition.latitude, geoposition.longitude);

  //     Placemark place = placemarks[0];
  //     print(place);
  //     setState(() {
  //       _currentAddress =
  //           "${place.street}, ${place.administrativeArea}, ${place.country}";
  //     });
  //     Provider.of<AppData>(context, listen: false)
  //         .updateuserAddress(_currentAddress!);

  //     setState(() {
  //       MySharedPreferences.saveUserAddress(_currentAddress!);
  //     });
  //   } catch (e) {
  //     print('catchcatchcatchcatchcatchcatchcatchcatch');

  //     print(e);
  //   }
  // }
}
