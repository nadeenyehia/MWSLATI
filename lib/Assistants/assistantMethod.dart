import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mwslati3/Assistants/requestAssistant.dart';
import 'package:mwslati3/DataHandler/appData.dart';
import 'package:mwslati3/Models/address.dart';
import 'package:mwslati3/Models/directDetails.dart';
import 'package:mwslati3/configMaps.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      //placeAddress=response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      placeAddress = st1 + "," + st2 + "," + st3 + "," + st4;
      Address userPickupAddress = Address(
        longitude: position.longitude,
        latitude: position.latitude,
        PlaceName: placeAddress,
      );

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickupAddress);
      Provider.of<AppData>(context, listen: false)
          .updateuserAddress(placeAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialposition, LatLng finalposition) async {
    late DirectionDetails directionDetails;
    String directionUrl1 =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialposition.latitude},${initialposition.longitude}&destination=${finalposition.latitude},${finalposition.longitude} &key=$mapKey";
    try {
      var res = await RequestAssistant.getRequest(directionUrl1);
      print(
          "resresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresres");
      print(res["routes"][0]["overview_polyline"]["points"]);
      print(
          "resresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresresres");

      // if (res == "failed") {
      //   return null;
      // }
      directionDetails = DirectionDetails(
          encodedPoints: res["routes"][0]["overview_polyline"]["points"],
          distanceText: res["routes"][0]["legs"][0]["distance"]["text"],
          distanceValue: res["routes"][0]["legs"][0]["distance"]["value"],
          durationText: res["routes"][0]["legs"][0]["duration"]["text"],
          durationValue: res["routes"][0]["legs"][0]["duration"]["value"]);
      // directionDetails.encodedPoints =res["routes"][0]["overview_polyline"]["points"];
      //directionDetails.distanceText =res["routes"][0]["legs"]["distance"]["text"];
      // directionDetails.distanceValue =res["routes"][0]["legs"]["distance"]["value"];
      // directionDetails.durationText =res["routes"][0]["legs"]["duration"]["text"];
      //directionDetails.durationValue =res["routes"][0]["legs"]["duration"]["value"];

    } catch (e) {
      print(
          'obtainPlaceDirectionDetailsdfjdfhjdfhdjfhdhjfdhfjdhjfdhjfdjfhdjfjfdhfjdfjdfhdjfdjfd');
      print(e);
    }
    return directionDetails;
  }
}
