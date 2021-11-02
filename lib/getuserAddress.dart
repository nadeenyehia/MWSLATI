import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mwslati3/Models/address.dart';
import 'package:mwslati3/sharedPreferences.dart';
import 'package:provider/provider.dart';

import 'DataHandler/appData.dart';

getCurrentLocation(BuildContext context) async {
  try {
    final geoposition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    MySharedPreferences.saveUserlong('${geoposition.longitude}');
    MySharedPreferences.saveUserlat('${geoposition.latitude}');

    getAddressFromLatLng(geoposition, context);
  } catch (e) {
    print('geoposition Erorr:' + e.toString());
  }
}

getAddressFromLatLng(final geoposition, BuildContext context) async {
  print(geoposition);
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        geoposition.latitude, geoposition.longitude);

    Placemark place = placemarks[0];
    print(place);
    Address address = Address(
      // PlaceId: PlaceId,
      PlaceName:
          "${place.street}, ${place.administrativeArea}, ${place.country}",
      latitude: geoposition.latitude,
      longitude: geoposition.longitude,
    );

    Provider.of<AppData>(context, listen: false)
        .updatePickUpLocationAddress(address);

    Provider.of<AppData>(context, listen: false).updateuserAddress(
        "${place.street}, ${place.administrativeArea}, ${place.country}");

    MySharedPreferences.saveUserAddress(
        "${place.street}, ${place.administrativeArea}, ${place.country}");
  } catch (e) {
    print('catchcatchcatchcatchcatchcatchcatchcatch');

    print(e);
  }
}
