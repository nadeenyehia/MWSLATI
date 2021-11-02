/*
import 'package:flutter/material.dart';
import 'package:mwslati3/AllWidgets/Divider.dart';
import 'package:mwslati3/AllWidgets/progressDialog.dart';
import 'package:mwslati3/Assistants/requestAssistant.dart';
import 'package:mwslati3/DataHandler/appData.dart';
import 'package:mwslati3/Models/address.dart';
import 'package:provider/provider.dart';
import 'package:mwslati3/configMaps.dart';
import '../configMaps.dart';
import 'package:mwslati3/Models/placePredictions.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffEditingController = TextEditingController();
   List<placePredictions>placePredictionsList=[];
  Widget build(BuildContext context) {
    // String PlaceAddress =Provider.of<AppData>(context).pickUpLocation.PlaceName??"";
    // pickUpTextEditingController.text=PlaceAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7)),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text(
                          "Set Drop off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText:
                                Provider
                                    .of<AppData>(context, listen: false)
                                    .userAddress
                                    .toString(),
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOffEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //Tile for predictions
          SizedBox(height: 10.0,),
          (placePredictionsList.length >0)
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
            child: ListView.separated(
              padding:EdgeInsets.all(0.0) ,
              itemBuilder: (context,index)
              {
                return PredictionTile( placePredictions: placePredictionsList[index],   );
              },
              separatorBuilder: (BuildContext context ,int index)=>DividerWidget(),
              itemCount: placePredictionsList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
          :Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:eg";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "ok") {
        var predictions = res["predictions"];

        var placeList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
           setState(() {
         late final placePredictionsList = placeList; //8baa
        });
      }
    }
  }
}
class PredictionTile extends StatelessWidget {
   final PlacePredictions placePredictions;

  PredictionTile({ required Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions, context);
      },
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0,),
                      Text(placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),),

                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),

      ),
    );
  }
    void getPlaceAddressDetails (String placeId,context)async
    {
      showDialog(
          context: context, builder: (BuildContext context)=>progressDialog(message: "setting Dropoff,Please wait..",)
      );
      String placeDetailsUrl="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=mapKey";
      var res=await RequestAssistant.getRequest(placeDetailsUrl);
      Navigator.pop(context);

      if (res=="failed")
        {
          return;
        }
      if (res["status"]=="OK")
        {
          Address address=Address();
          address.placeName=res["result"]["name"]; //
          address.placeId=placeId;    //
          address.latitude=res["result"]["geometry"]["location"]["lat"];
          address.longitude=res["result"]["geometry"]["location"]["lng"];

          Provider.of<AppData>(context,listen:false).updateDropOffLocationAddress(address);
          print("This is Drop off Location ::");
          print("address.placeName");
          }
        }
    }
*/
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mwslati3/AllWidgets/Divider.dart';
import 'package:mwslati3/AllWidgets/progressDialog.dart';
import 'package:mwslati3/Allscreens/mainscreen.dart';
import 'package:mwslati3/Assistants/requestAssistant.dart';
import 'package:mwslati3/DataHandler/appData.dart';
import 'package:mwslati3/Models/address.dart';
import 'package:mwslati3/Models/placePredictions.dart';
import 'package:provider/provider.dart';
import 'package:mwslati3/configMaps.dart';
import '../configMaps.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];
  Widget build(BuildContext context) {
    // String PlaceAddress =Provider.of<AppData>(context).pickUpLocation.PlaceName??"";
    // pickUpTextEditingController.text=PlaceAddress;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        primary: true,
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7)),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text(
                          "Set Drop off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText:
                                    Provider.of<AppData>(context, listen: false)
                                        .userAddress
                                        .toString(),
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOffEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //tile for predictions
          SizedBox(
            height: 10,
          ),
          (placePredictionList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    primary: false,
                    itemBuilder: (context, index) {
                      return PredictionTile(
                        placePredictions: placePredictionList[index],
                        key: ValueKey(index),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        DividerWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:eg";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var PlacesList = (predictions as List)
            .map((e) => PlacePredictions.fromjson(e))
            .toList();
        setState(() {
          placePredictionList = PlacesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredictionTile({required Key key, required this.placePredictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void getPlaceAddressDetails(String PlaceId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => progressDialog(
              message: "setting Dropoff,please wait...",
            ));
    try {
      // ignore: non_constant_identifier_names
      String PlaceDetailsUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$PlaceId&key=$mapKey";
      var res = await RequestAssistant.getRequest(PlaceDetailsUrl);
      print(
          "RESSSSSSSSSSSSSSSSSSSSSSSS:${res['result']}"); // if (res['result'] ==null) {
      // Navigator.pop(context);    }
      // else if
      // (res["result"] != null) {

      Address address = Address(
        PlaceId: PlaceId,
        PlaceName: res["result"]["name"],
        latitude: res["result"]["geometry"]["location"]["lat"],
        longitude: res["result"]["geometry"]["location"]["lng"],
      );

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print("this is Drop off Location ::");
      print(res["result"]["name"]);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainScreen(),
        ),
      );

      //  }
    } catch (e) {
      print(
          'Catccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccch');
      Navigator.of(context).pop();
      print(e);
    }
  }
}
