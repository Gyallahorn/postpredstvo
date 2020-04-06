import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:pospredsvto/cabinet/cabinet.dart';
import 'package:pospredsvto/map/map_profile.dart';
import 'package:pospredsvto/map/map_test.dart';
import 'package:pospredsvto/quiz/quiz.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

import 'marker_list.dart';

class MapFrame extends StatefulWidget {
  @override
  _MapFrameState createState() => _MapFrameState();
}

List<Map<String, dynamic>> markers = [];

class _MapFrameState extends State<MapFrame> {
  int i = 0;
  var dist;
  bool listCalled = false;
  bool menuPressed = false;
  bool profilePressed = false;
  bool testPressed = false;
  var panelContent;
  var menuPanelContent;
  var distance = "выберите маркер";
  List<Marker> allMarkers = [];
  List<Marker> _markers = [];
  Completer<GoogleMapController> _controller = Completer();
  // Routing vars
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ");

  List<BoxShadow> boxShad = const <BoxShadow>[
    BoxShadow(color: Colors.black, blurRadius: 8.0)
  ];

  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));

  var listOfPlaces = List<Widget>();
  var listOfFloatButtons2 = List<Widget>();
  var listOfFloatButtons1 = List<Widget>();
  var listOfFloatButtons = List<Widget>();
  var makeRouteButton0;
  var makeRouteButtonCancel;
  var makeRouteButton2;
  var makeRouteButton1;
  var makeRoutePanel;

  //Map
  GoogleMapController myMapController;
  // final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  static Position position;
  Widget _child;
  double zoom = 12;
  Position csreenPos;
  PanelController panelController = new PanelController();
  var markList = new MarkerList();

//get my position
  void getGeo() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

//set list view from array
  void listBuilder() async {
    for (int i = 0; i < markList.markersList.length; i++) {
      listOfPlaces.add(GestureDetector(
        onTap: () => setState(() {
          myMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(markList.markersList[i]["lng"],
                    markList.markersList[i]["ltd"]),
                zoom: 12,
              ),
            ),
          );
          routeBuilder(i, makeRouteButton2, makeRouteButton1);
        }),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      markList.markersList[i]["name"],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      markList.markersList[i]["street"],
                      style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 14,
            )
          ],
        ),
      ));
    }
  }

  void routeBuilder(int i, makeRouteButton, makeRouteButton1) {
    makeRouteButton0 = makeRouteButton1;
    makeRouteButtonCancel = makeRouteButton;
    setState(() {
      dist = distanceBetwee(
          markList.markersList[i]["lng"],
          markList.markersList[i]["ltd"],
          position.latitude,
          position.longitude);
      if (dist < 1.0) {
        dist = dist * 1000;
        dist = dist.round();
        distance = dist.toString() + " м";
      } else {
        dist = dist.round();
        distance = dist.toString() + " Км";
      }
      panelContent = Column(
        children: <Widget>[
          Container(
            width: 50,
            child: Divider(
              thickness: 5,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 17,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(
                              markList.markersList[i]["img"]))),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        markList.markersList[i]["name"],
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        markList.markersList[i]["street"],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    )
                  ],
                )
              ],
            ),
            height: 60,
          ),
          SizedBox(
            height: 17,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: makeRouteButton0,
            height: 60,
          ),
          SizedBox(
            height: 17,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 30,
            child: Text(
              'Пешком ${distance}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              markList.markersList[i]["desc"],
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          )
        ],
      );
    });
  }

  getSomePoints(double lng, double ltd) async {
    var permissions =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermission =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(position.latitude, position.longitude),
          destination: LatLng(lng, ltd),
          mode: RouteMode.walking);
    }
  }

  void setMapPins(double lat, double lng) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("dest"),
          position: LatLng(position.latitude, position.longitude)));
      _markers
          .add(Marker(markerId: MarkerId("dest"), position: LatLng(lat, lng)));
    });
  }

  double distanceBetwee(lat1, lon1, lat2, lon2) {
    var pi = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * pi) / 2 +
        cos(lat1 * pi) * cos(lat2 * pi) * (1 - cos((lon2 - lon1) * pi)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    makeRouteButton1 = Container(
      width: 380,
      height: 60,
      child: RaisedButton(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 70,
              ),
              Icon(
                Icons.directions_walk,
                color: Colors.blue,
              ),
              Text("Проложить маршрут",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.blue,
                  ))
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.blue)),
          onPressed: () => setState(() {
                makeRouteButton0 = makeRouteButtonCancel;
              })),
    );

// Profile,Test, Media,Language buttons
    listOfFloatButtons1 = <Widget>[
      SizedBox(
        height: 127,
      ),
      GestureDetector(
        onTap: () => setState(() {
          profilePressed = true;
          testPressed = false;
          panelContent = MyCabinet();
          panelController.open();
        }),
        child: Container(
          color: Colors.transparent,
          height: 80,
          width: 80,
          child: new Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.account_circle,
                  size: 30,
                  color: Colors.blue,
                ),
                Text('Профиль')
              ],
            ),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () => setState(() {
          testPressed = true;
          profilePressed = false;
          panelContent = Quiz();
          panelController.open();
        }),
        child: Container(
          color: Colors.transparent,
          height: 80,
          width: 80,
          child: new Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.toc,
                  size: 30,
                  color: Colors.blue,
                ),
                Text('Тесты')
              ],
            ),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      GestureDetector(
        child: Container(
          color: Colors.transparent,
          height: 80,
          width: 80,
          child: new Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.photo_library,
                  size: 30,
                  color: Colors.blue,
                ),
                Text('Медиа')
              ],
            ),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ), //find me
      GestureDetector(
        child: Container(
          color: Colors.transparent,
          height: 80,
          width: 80,
          child: new Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.language,
                  size: 30,
                  color: Colors.blue,
                ),
                Text('Язык')
              ],
            ),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ),
      SizedBox(
        height: 70,
      ),
      GestureDetector(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.keyboard_arrow_up,
            color: Colors.blue,
          ),
        ),
      )
    ];

// map buttons
    listOfFloatButtons2 = <Widget>[
      SizedBox(
        height: 200,
      ),

      GestureDetector(
        onTap: () => setState(() {
          panelContent = menuPanelContent;
          panelController.open();
        }),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.menu,
            color: Colors.blue,
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () => {myMapController.animateCamera(CameraUpdate.zoomIn())},
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.blue,
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () => {myMapController.animateCamera(CameraUpdate.zoomOut())},
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.remove,
            color: Colors.blue,
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ), //find me
      GestureDetector(
        onTap: () => setState(() {
          myMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 12,
              ),
            ),
          );
        }),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.near_me,
            color: Colors.blue,
          ),
        ),
      ),
      SizedBox(
        height: 70,
      ),
      GestureDetector(
        onTap: () => setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Container(
                  color: Colors.white.withOpacity(100),
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    children: listOfFloatButtons1,
                  ),
                ));
              });
          panelContent = MyCabinet();
        }),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.keyboard_arrow_up,
            color: Colors.blue,
          ),
        ),
      )
    ];

    menuPanelContent = Material(
        child: Column(
      children: <Widget>[
        Container(
          width: 50,
          child: Divider(
            thickness: 5,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 17,
        ),
        Expanded(
          child: ListView(
            children: listOfPlaces,
          ),
        )
      ],
    ));

    panelContent = menuPanelContent;

    getCurrentLocation();
    for (int i = 0; i < markList.markersList.length; i++) {
      allMarkers.add(Marker(
        markerId: MarkerId(i.toString()),
        draggable: false,
        position: LatLng(
            markList.markersList[i]["lng"], markList.markersList[i]["ltd"]),
        onTap: () => setState(() {
          dist = distanceBetwee(
              markList.markersList[i]["lng"],
              markList.markersList[i]["ltd"],
              position.latitude,
              position.longitude);
          if (dist < 1.0) {
            dist = dist * 1000;
            dist = dist.round();
            distance = dist.toString() + " м";
          } else {
            dist = dist.round();
            distance = dist.toString() + " Км";
          }
          print(distance);
          print("marker " + i.toString() + " tapped");

          routeBuilder(i, makeRouteButton2, makeRouteButton1);
          panelController.open();
        }),
      ));
    }
    getSomePoints(
        markList.markersList[i]["lng"], markList.markersList[i]["ltd"]);
    super.initState();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
    });
  }

  Widget build(BuildContext context) {
    getGeo();

    void onMapCreated(GoogleMapController controller) async {
      setState(() {
        myMapController = controller;
        polyline.add(Polyline(
            polylineId: PolylineId('route1'),
            visible: true,
            points: routeCoords,
            width: 4,
            color: Colors.blue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap));
      });
    }

    if (!listCalled) {
      listBuilder();
      listCalled = true;
    } else {
      print('listAlredyCalled');
    }
    if (!menuPressed) {
      return Material(
        child: Scaffold(
            body: SlidingUpPanel(
          controller: panelController,
          borderRadius: radius,
          boxShadow: boxShad,
          minHeight: 20,
          maxHeight: 350,
          //Panel
          panel: panelContent,
          //MainScreen
          body: Scaffold(
            floatingActionButton: Column(children: listOfFloatButtons2),
            body: GoogleMap(
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: zoom,
              ),
              markers: Set<Marker>.of(allMarkers),
              mapType: MapType.normal,
              onMapCreated: onMapCreated,
            ),
          ),
        )),
      );
    }
//
    if (profilePressed) {
      return MapProfileFrame();
    }
//
    if (testPressed) {
      return MapTestFrame();
    }
  }
}
