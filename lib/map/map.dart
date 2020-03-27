import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:pospredsvto/map/sliderContent.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

class MapFrame extends StatefulWidget {
  @override
  _MapFrameState createState() => _MapFrameState();
}

List<Map<String, dynamic>> markers = [];
void getGeo() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

class _MapFrameState extends State<MapFrame> {
  int i = 0;
  var dist;
  bool listCalled = false;
  var distance = "выберите маркер";
  List<Marker> allMarkers = [];
  List<Marker> _markers = [];
  Completer<GoogleMapController> _controller = Completer();
  // Routing vars
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ");

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

  //Map
  GoogleMapController myMapController;
  // final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  static Position position;
  Widget _child;
  double zoom = 12;
  Position csreenPos;
  PanelController panelController = new PanelController();

  List<Map<String, dynamic>> markersList = [
    {
      "lng": 62.03484,
      "ltd": 129.7420426,
      "name": "Пример 1",
      "street": "Под Пример 1"
    },
    {
      "lng": 62.0311268,
      "ltd": 129.760587,
      "name": "Пример 2",
      "street": "Под Пример 1"
    },
    {
      "lng": 62.0167415,
      "ltd": 129.7045627,
      "name": "Пример 3",
      "street": "Под Пример 1"
    },
    {
      "lng": 62.03485,
      "ltd": 129.7420466,
      "name": "Пример 4",
      "street": "Под Пример 1"
    },
    {
      "lng": 62.03478,
      "ltd": 129.7420444,
      "name": "Пример 5",
      "street": "Под Пример 1"
    }
  ];

  var listOfPlaces = List<Widget>();

  void listBuilder() async {
    for (int i = 0; i < markersList.length; i++) {
      listOfPlaces.add(GestureDetector(
        onTap: () => {
          myMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(markersList[i]["lng"], markersList[i]["ltd"]),
                zoom: 12,
              ),
            ),
          ),
          panelController.close()
        },
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
                      markersList[i]["name"],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      markersList[i]["street"],
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

  @override
  void initState() {
    double distanceBetwee(lat1, lon1, lat2, lon2) {
      var pi = 0.017453292519943295;
      var a = 0.5 -
          cos((lat2 - lat1) * pi) / 2 +
          cos(lat1 * pi) * cos(lat2 * pi) * (1 - cos((lon2 - lon1) * pi)) / 2;
      return 12742 * asin(sqrt(a));
    }

    getCurrentLocation();
    for (int i = 0; i < markersList.length; i++) {
      allMarkers.add(Marker(
        markerId: MarkerId(i.toString()),
        draggable: false,
        position: LatLng(markersList[i]["lng"], markersList[i]["ltd"]),
        onTap: () => setState(() {
          dist = distanceBetwee(markersList[i]["lng"], markersList[i]["ltd"],
              position.latitude, position.longitude);
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
        }),
      ));
    }
    getSomePoints(markersList[i]["lng"], markersList[i]["ltd"]);
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

    List<BoxShadow> boxShad = const <BoxShadow>[
      BoxShadow(color: Colors.black, blurRadius: 8.0)
    ];

    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));

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
    return Material(
      child: Scaffold(
          body: SlidingUpPanel(
        controller: panelController,
        borderRadius: radius,
        boxShadow: boxShad,
        minHeight: 20,
        maxHeight: 350,
        panel: Material(
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
        )
            //     child: Column(
            //   children: <Widget>[
            //     Container(
            //       width: 50,
            //       child: Divider(
            //         thickness: 5,
            //         color: Colors.grey,
            //       ),
            //     ),
            //     SizedBox(
            //       height: 17,
            //     ),
            //     Container(
            //       height: 44,
            //       width: 350,
            //       color: Colors.indigo,
            //     ),
            //     SizedBox(
            //       height: 17,
            //     ),
            //     Container(
            //       height: 44,
            //       width: 350,
            //       color: Colors.lime,
            //     ),
            //     SizedBox(
            //       height: 17,
            //     ),
            //     Container(
            //       height: 30,
            //       child: Text(
            //         'Пешком ${distance}',
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            //       ),
            //     )
            //   ],
            // )
            ),
        body: Scaffold(
          floatingActionButton: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SliderContent(
                  //               myMapController: myMapController,
                  //             )));
                },
                child: CircleAvatar(
                  child: Icon(Icons.menu),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () =>
                    {myMapController.animateCamera(CameraUpdate.zoomIn())},
                child: CircleAvatar(
                  child: Icon(Icons.add),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () =>
                    {myMapController.animateCamera(CameraUpdate.zoomOut())},
                child: CircleAvatar(
                  child: Icon(Icons.remove),
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
                  child: Icon(Icons.near_me),
                ),
              ),
            ],
          ),
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
}
