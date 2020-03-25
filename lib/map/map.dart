import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
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

  setPolilines() async {}

  //Map
  GoogleMapController myMapController;
  // final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  static Position position;
  Widget _child;
  double zoom = 12;
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

          // setMapPins(huy[i]["lng"], huy[i]["ltd"])
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

    Future<void> _zooming(Position pos) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(pos.latitude, pos.longitude), zoom: 15.0)));
    }

    return Material(
      child: GoogleMap(
        polylines: polyline,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: zoom,
        ),
        markers: Set<Marker>.of(allMarkers),
        mapType: MapType.normal,
        onMapCreated: onMapCreated,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
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
}
