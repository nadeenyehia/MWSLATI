import 'dart:async';
/*import 'dart:html';*/
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mwslati3/AllWidgets/Divider.dart';
import 'package:mwslati3/AllWidgets/progressDialog.dart';
import 'package:mwslati3/Allscreens/loginScreen.dart';
import 'package:mwslati3/Allscreens/searchScreen.dart';
import 'package:mwslati3/Assistants/assistantMethod.dart';
import 'package:mwslati3/DataHandler/appData.dart';
import 'package:mwslati3/Models/users.dart';
import 'package:mwslati3/credit%20card/credit_card.dart';
import 'package:mwslati3/getuserAddress.dart';
import 'package:mwslati3/qr%20code/qr_scan_page.dart';

import 'package:mwslati3/sharedPreferences.dart';
import 'package:mwslati3/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<LatLng> plinecoordinates = [];
  Set<Polyline> polylineSet = {};

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // var position2 = currentPosition;
    LatLng latLaPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLaPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("this is your Address ::" + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target:
        LatLng((double.parse(Users.userLat!)), (double.parse(Users.userLong!))),
    zoom: 14.4746,
  );
  static final CameraPosition _kGooglePlex2 = CameraPosition(
    target:
        LatLng((double.parse(Users.userLat!)), (double.parse(Users.userLong!))),
    zoom: 14.4746,
  );

  getUserData() async {
    Users.userlogIn = await MySharedPreferences.getUserSingIn() ?? false;
    Users.userAdders = await MySharedPreferences.getUserAddress();
    Users.userLat = await MySharedPreferences.getUserLat();
    Users.userLong = await MySharedPreferences.getUserlong();
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation(context);

    getUserData();
  }

  String? _currentAddress;

  Widget build(BuildContext context) {
    print(
        "___________________________________________________________________");
    print(Provider.of<AppData>(context, listen: false).dropOffLocation);
    print(
        "___________________________________________________________________");

    if (Provider.of<AppData>(context, listen: false).dropOffLocation != null) {
      getPlaceDirection();
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer Header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/user_icon.png",
                        height: 65.0,
                        width: 65.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "profile Name",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Brand-Bold"),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text("Visit profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(
                height: 12.0,
              ),
              //Drawer Body Controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "Your Trips",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CrediteCard(),),);
                },
                leading: Icon(Icons.credit_card),
                title: Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QRScanPage(),
                    ),
                  );
                },
                leading: Icon(Icons.qr_code_scanner),
                title: Text(
                  "Payment",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "Fares and Tickets",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "Bus Routes",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "FAQ",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "Help",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "About MWSLATI",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    "Sign out",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: (Users.userLat == null)
          ? Center(
              child: Container(
                child: MaterialButton(
                  onPressed: () async {
                    try {
                      final geoposition = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );
                      setState(() {
                        MySharedPreferences.saveUserlong(
                            '${geoposition.longitude}');
                        MySharedPreferences.saveUserlat(
                            '${geoposition.latitude}');
                      });
                      Navigator.of(context)
                          .pushReplacementNamed(SplashScreen.route);
                    } catch (e) {
                      print('geoposition Erorr:' + e.toString());
                    }
                  },
                  color: Colors.yellow,
                  child: Text(
                    'Please Allow your location first..',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  polylines: polylineSet,
                  markers: markersSet,
                  circles: circlesSet,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;

                    setState(() {
                      bottomPaddingOfMap = 300.0;
                    });

                    locatePosition();
                  },
                ),
                //HamburgerButton for Drawer
                Positioned(
                  top: 45.0,
                  left: 22.0,
                  child: GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        radius: 20.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.0),
                          Text(
                            "Hi There",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            "Where to?",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ),
                              );
                              // var res = await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SearchScreen(),
                              //   ),
                              // );
                              // if (res == "obtainDirection") {
                              //   await getPlaceDirection();
                              // }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text("Search drop off")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.0),
                          Row(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.home,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      (Provider.of<AppData>(context,
                                                      listen: false)
                                                  .userAddress
                                                  .toString()
                                                  .length <=
                                              50)
                                          ? Provider.of<AppData>(context,
                                                  listen: false)
                                              .userAddress
                                              .toString()
                                          : Provider.of<AppData>(context,
                                                      listen: false)
                                                  .userAddress
                                                  .toString()
                                                  .substring(0, 50) +
                                              "...",
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "Your living home address",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10.0),
                          DividerWidget(),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.work,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Add Work"),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Your office address",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialpos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
    print(initialpos!.latitude!);
    print(initialpos.longitude!);
    print(finalPos!.latitude!);
    print(finalPos.longitude!);

    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');

    var pickUpLatLng = LatLng(initialpos.latitude!, initialpos.longitude!);
    var dropOffLatLng = LatLng(finalPos.latitude!, finalPos.longitude!);
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => progressDialog(
    //           message: "please wait...",
    //         ));
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        LatLng(initialpos.latitude!, initialpos.longitude!),
        LatLng(finalPos.latitude!, finalPos.longitude!));
    // Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    // polylineSet.clear();
    plinecoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach(
        (PointLatLng pointLatLng) {
          plinecoordinates.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude),
          );
        },
      );
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: PolylineId('PolylineID'),
        jointType: JointType.round,
        points: plinecoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latlngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latlngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latlngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latlngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latlngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latlngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: initialpos.placeName, snippet: "my location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );
    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.deepPurple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.deepPurple,
        circleId: CircleId("dropOffId"));

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}
