import 'package:flutter/cupertino.dart';
import 'package:mwslati3/Models/address.dart';

class AppData extends ChangeNotifier {
  // ignore: avoid_init_to_null
  String? userAddress = "Add home";
  Address? pickUpLocation, dropOffLocation;
  void updateuserAddress(String adress) {
    userAddress = adress;
    notifyListeners();
  }

  void updatePickUpLocationAddress(Address pickupAddress) {
    this.pickUpLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    this.dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
