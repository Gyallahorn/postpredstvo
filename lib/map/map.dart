import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
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

  List<Map<String, dynamic>> huy = [
    {"lng": 62.03484, "ltd": 129.7420426},
    {"lng": 62.0311268, "ltd": 129.760587},
    {"lng": 62.0167415, "ltd": 129.7045627},
    {"lng": 62.03485, "ltd": 129.7420466},
    {"lng": 62.03478, "ltd": 129.7420444}
  ];

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
    for (int i = 0; i < 5; i++) {
      allMarkers.add(Marker(
        markerId: MarkerId(i.toString()),
        draggable: false,
        position: LatLng(huy[i]["lng"], huy[i]["ltd"]),
        onTap: () => {
          dist = distanceBetwee(huy[i]["lng"], huy[i]["ltd"], position.latitude,
              position.longitude),
          print(dist),
          print("marker " + i.toString() + " tapped"),
        },
      ));
    }
    getSomePoints(huy[i]["lng"], huy[i]["ltd"]);
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
    List<Widget> floatButtons = [];
    List<BoxShadow> boxShad = const <BoxShadow>[
      BoxShadow(color: Colors.black, blurRadius: 8.0)
    ];
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));

    ;

    Future<void> _zooming(Position pos) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(pos.latitude, pos.longitude), zoom: 15.0)));
    }

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

    return Scaffold(
        body: SlidingUpPanel(
      borderRadius: radius,
      boxShadow: boxShad,
      minHeight: 0,
      panel: Center(
        child: Text('lolol'),
      ),
      body: Scaffold(
        floatingActionButton: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            GestureDetector(
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
                print('hi');
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
    ));
  }
}
