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

List<Map<String, dynamic>> markers = [
  {"latitude": "62.034125", "longitude": "129.713635"},
  {"latitude": "62.034225", "longitude": "129.713635"},
  {"latitude": "62.034325", "longitude": "129.713635"},
  {"latitude": "62.034425", "longitude": "129.713635"},
];
void getGeo() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

class _MapFrameState extends State<MapFrame> {
  //Markers
  // BitmapDescriptor pinLocationIcon;
  // Set<Marker> _markerss={};
  // Completer<GoogleMapController> =_controller = Completer();
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
  double zoom = 10;

  @override
  void initState() {
    getCurrentLocation();
    getSomePoints();

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
        markers: this.myMarker(),
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
}
