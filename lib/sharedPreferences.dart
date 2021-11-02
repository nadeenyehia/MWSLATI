import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static String sharedPrefUserLogin = 'UserLogin';
  static String sharedPrefUserAddress = 'UserAddress';
  static String sharedPrefUserLat = 'Lat';
  static String sharedPrefUserLong = 'Long';

  //save data
  static Future<bool> saveUserSingIn(bool isSingin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefUserLogin, isSingin);
  }

  static Future<bool> saveUserAddress(String address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserAddress, address);
  }

  static Future<bool> saveUserlat(String lat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserLat, lat);
  }

  static Future<bool> saveUserlong(String long) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserLong, long);
  }

  // getdata
  static getUserSingIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isSingin = (preferences.getBool(sharedPrefUserLogin) ?? false);
    return isSingin;
  }

  static getUserLat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? lat = preferences.getString(sharedPrefUserLat);
    return lat;
  }

  static getUserlong() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? long = preferences.getString(sharedPrefUserLong);
    return long;
  }

  static getUserAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var address = (preferences.getString(sharedPrefUserAddress));
    return address;
  }
}
