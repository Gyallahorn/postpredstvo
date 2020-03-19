import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

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
  List<Marker> allMarkers = [];

  Completer<GoogleMapController> _controller = Completer();
  // Routing vars
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ");

  getSomePoints() async {
    var permissions =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermission =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(62.034135, 129.723635),
          destination: LatLng(62.034125, 129.713635),
          mode: RouteMode.walking);
    }
  }

  //Map
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  static Position position;
  Widget _child;
  double zoom = 12;
  List<Map<String, dynamic>> huy = [
    {"lng": 62.03484},
    {"lng": 62.03480},
    {"lng": 62.03452},
    {"lng": 62.03485},
    {"lng": 62.03478}
  ];
  @override
  void initState() {
    getCurrentLocation();
    getSomePoints();

    super.initState();
    for (int i = 0; i < 5; i++) {
      print(huy[i]["lng"]);
      allMarkers.add(Marker(
        markerId: MarkerId(i.toString()),
        draggable: false,
        position: LatLng(huy[i]["lng"], 129.7420426),
        onTap: () => {print("hello Marker tapped")},
      ));
    }
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
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller.complete(controller);

            polyline.add(Polyline(
                polylineId: PolylineId('route1R'),
                visible: true,
                points: routeCoords,
                width: 4,
                color: Colors.blue,
                startCap: Cap.roundCap,
                endCap: Cap.buttCap));
          });
        },
      ),
    );
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_mainLocation.toString()),
        position: LatLng(62.034125, 129.713635),
        infoWindow: InfoWindow(
          title: 'Historical City',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers;
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
