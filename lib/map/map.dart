import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

import 'marker_list.dart';

class MapFrame extends StatefulWidget {
  final int diff;
  final int index;
  final double lng;
  final double ltd;
  final String name;

  const MapFrame(this.diff, this.index, this.lng, this.ltd, this.name);

  @override
  _MapFrameState createState() => _MapFrameState();
}

String googleApiKey = 'AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ';
List<Map<String, dynamic>> markers = [];

GoogleMapPolyline googleMapPolyline =
    new GoogleMapPolyline(apiKey: "AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ");

class _MapFrameState extends State<MapFrame> {
  var diff;
  //location
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  int i = 0;
  var dist;
  var distM;
  bool listCalled = false;
  bool menuPressed = false;
  bool profilePressed = false;
  bool testPressed = false;
  var visited = false;
  var panelContent;
  var routeProgress;
  var menuPanelContent;
  var distance = "выберите маркер";
  List visitedPlases = [];
  var _visitedPlasesCount = 0;
  double _maxHeight = 225;
  bool routeMode = true;

  int _polylineCount = 1;
  List<Marker> allMarkers = [];
  List<Marker> _markers = [];
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  List<LatLng> routingCoords = [];

  GoogleMapController _controller;
  // Routing vars
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;

  List<BoxShadow> boxShad = const <BoxShadow>[
    BoxShadow(color: Colors.black, blurRadius: 8.0)
  ];

  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));
  var pressed = 0;
  var listOfPlaces = List<Widget>();
  var listOfFloatButtons2 = List<Widget>();
  var listOfFloatButtons1 = List<Widget>();
  SharedPreferences sharedPreferences;
  var listOfFloatButtons = List<Widget>();
  var makeRouteButton0;
  var choosedMarker;
  var makeRouteButtonCancel;
  var makeRouteButton2;
  var makeRouteButton1;
  var makeRoutePanel;
  var markerAbout;
  var firstEnter = true;
  bool routeButtonPressed = false;
  bool _slidingPanelClosed = false;
  var places;
  //Map
  GoogleMapController myMapController;
  // final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  Position position;
  Position lposition;
  Widget _child;
  double zoom = 12;
  Position csreenPos;
  PanelController panelController = new PanelController();
  var markList = MarkerList();
  var markers;
  LatLng startPoint;
  var token;
  bool profileGetted = false;
  var diffPlaces;
  var diffUrl;
  bool _flag = true;
  bool _onLoad = false;

  // checkService() async* {
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  // }

  // checkPermissions() async* {
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  // }
  Dispose() {
    super.dispose();
  }

  getGeo() async {
    if (position == null) {
      position = await Geolocator().getLastKnownPosition();
    }
    position = await Geolocator().getCurrentPosition();
    if (_flag) {
      addMarkers();
      setState(() {
        _flag = false;
      });
    }
  }

  // _getCurrentLocation() async* {
  //   _locationData = await location.getLocation();

  //   // position = _locationData;
  //   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //   geolocator.getCurrentPosition().then((Position pos) {
  //     addMarkers();

  //     setState(() {
  //       position = pos;
  //       print(position.toString());
  //     });
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }

  getSomePoints(double lng, double ltd) async {
    print("getSomePoints called");
    List<LatLng> _coordinates =
        await googleMapPolyline.getCoordinatesWithLocation(
            origin: LatLng(position.latitude, position.longitude),
            destination: LatLng(lng, ltd),
            mode: RouteMode.walking);
    setState(() {
      _polylines.clear();
      _addPolyline(_coordinates);
    });
  }

  void success() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Поздравляю!"),
            content: Text("Место посещено"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ок"),
                onPressed: () {
                  panelController.close();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void tooFar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(""),
            content: Text("Вы слишком далеко"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ок"),
                onPressed: () {
                  panelController.close();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // #TODO Replace with JSON
  void getDiffMarkers() async {
    diff = widget.diff;

    if (diff == 0) {
      markers = markList.easyMarkersList;
      diffPlaces = "e_places";
      diffUrl = "Easy";
    }
    if (diff == 1) {
      markers = markList.normalMarkersList;
      diffPlaces = "n_places";
      diffUrl = "Norm";
    } else {
      markers = markList.hardMarkersList;
      diffPlaces = "h_places";
      diffUrl = "Hard";
    }
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: _coordinates,
        width: 5);
    if (this.mounted) {
      setState(() {
        _polylines[id] = polyline;
      });
    }
  }

  double distanceBetwee(lat1, lon1, lat2, lon2) {
    var pi = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * pi) / 2 +
        cos(lat1 * pi) * cos(lat2 * pi) * (1 - cos((lon2 - lon1) * pi)) / 2;
    return 12742 * asin(sqrt(a));
  }
  // Get Locations

//Post locations

  Future<String> _sendRequestUpdateLocations() async {
    var jsonResponse;
    print("User token:" + token);

    if (token != null) {
      var response = await http.post(
        urlHost + '/api/user/updateEasyLocations',
        body: {"lng": widget.lng.toString(), "ltd": widget.ltd.toString()},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      jsonResponse = json.decode(response.body);
      if (jsonResponse["message"] == "succes") {
        setState(() {
          _onLoad = false;
          _flag = true;
          visited = true;
        });
        success();
        print("Success");
      } else {
        print("error something went wrong");
      }
    }
    return "Succes";
  }

  // getVisitedPlaces() {
  //   if (visitedPlases.length < 2) {
  //     print(markList.hardMarkersList.length.toString());
  //     for (int i = 0; i < markList.hardMarkersList.length; i++) {
  //       visitedPlases.add(0);
  //     }
  //   }
  // }

  markerAboutBuilder(int i) {
    setState(() {
      print("markerAboutBuilder called");
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
            height: 35,
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
                          image:
                              new NetworkImage(markers[widget.index]["img"]))),
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
                      width: 300,
                      padding: EdgeInsets.only(left: 10),
                      child: AutoSizeText(
                        widget.name,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 60,
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        markers[widget.index]["street"],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    )
                  ],
                )
              ],
            ),
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
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              markers[widget.index]["desc"],
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          visited
              ? Text(" Место посещено ")
              : FlatButton.icon(
                  onPressed: () {
                    if (distanceBetwee(widget.lng, widget.ltd,
                            position.latitude, position.longitude) <
                        0.2) {
                      _sendRequestUpdateLocations();
                      setState(() {
                        _onLoad = true;
                      });
                    } else {
                      tooFar();
                    }
                  },
                  icon: !_onLoad
                      ? Icon(Icons.done_outline)
                      : CircularProgressIndicator(),
                  label: Text("Я здесь"))
        ],
      );
      panelController.open();
    });
  }

  void setPolylines() async {
    if (markers[widget.index]["ltd"] == null) {
      print("array is null");
    }

    print("array found");
    List<LatLng> _coordinates =
        await googleMapPolyline.getCoordinatesWithLocation(
            origin: LatLng(position.latitude, position.longitude),
            destination: LatLng(widget.lng, widget.ltd),
            mode: routeMode ? RouteMode.walking : RouteMode.driving);
    _addPolyline(_coordinates);
    if (this.mounted) {
      setState(() {
        listCalled = true;
      });
    }
  }

  setMapButtons() {
    setState(() {
      // map buttons
      listOfFloatButtons = <Widget>[
        SizedBox(
          height: 350,
        ),
        GestureDetector(
          onTap: () {
            // _getCurrentLocation();
            if (this.mounted) {
              setState(() {
                myMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 12,
                    ),
                  ),
                );
              });
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.gps_fixed,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(
          height: 70,
        ),
      ];
    });
  }

  // panel content
  setMenuPanelContent() {
    setState(() {
      panelContent = Material(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              // onTap: () {
              //   panelController.open();
              // },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    "МАРШРУТ ТУРА",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text("Тур только начался, продолжайте движение"),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "${_visitedPlasesCount.toString()} из ${markers.length}",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(
                "Текущие результаты",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 110,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        color: routeMode ? Colors.grey[200] : Colors.grey[400],
                        onPressed: () {
                          _polylines.clear();
                          setPolylines();
                          if (this.mounted) {
                            setState(() {
                              routeMode = false;
                              listCalled = true;
                            });
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.directions_walk),
                          ],
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                        color: routeMode ? Colors.grey[400] : Colors.grey[200],
                        onPressed: () {
                          _polylines.clear();
                          setPolylines();
                          if (this.mounted) {
                            setState(() {
                              routeMode = true;
                              listCalled = true;
                            });
                          }
                        },
                        child: Row(
                          children: <Widget>[Icon(Icons.directions_car)],
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  addMarkers() {
    setState(() {
      allMarkers.add(Marker(
        markerId: MarkerId(i.toString()),
        draggable: false,
        position: LatLng(widget.lng, widget.ltd),
        onTap: () => setState(() {
          zoom = 15;
          //calc distance
          dist = distanceBetwee(
              widget.lng, widget.ltd, position.latitude, position.longitude);
          if (dist < 1.0) {
            dist = dist * 1000;
            dist = dist.round();
            distM = dist;
            choosedMarker = i;
            distance = dist.toString() + " м";
          } else {
            dist = dist.round();
            distM = dist * 1000;
            choosedMarker = i;
            distance = dist.toString() + " Км";
          }
          markerAboutBuilder(i);

          _maxHeight = 300;
        }),
      ));
      print("marker added!");
      i++;

      print("My marker added!");
      allMarkers.add(Marker(
        markerId: MarkerId(i.toString()),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(20),
        position: LatLng(position.latitude, position.longitude),
      ));
      setPolylines();
    });
  }

  // addMarkers() {
  //   setState(() {
  //     for (int i = 0; i < markers.length; i++) {
  //       allMarkers.add(Marker(
  //         markerId: MarkerId(i.toString()),
  //         draggable: false,
  //         position: LatLng(markers[i]["lng"], markers[i]["ltd"]),
  //         onTap: () => setState(() {
  //           //calc distance
  //           dist = distanceBetwee(markers[i]["lng"], markers[i]["ltd"],
  //               position.latitude, position.longitude);
  //           if (dist < 1.0) {
  //             dist = dist * 1000;
  //             dist = dist.round();
  //             distM = dist;
  //             choosedMarker = i;
  //             distance = dist.toString() + " м";
  //           } else {
  //             dist = dist.round();
  //             distM = dist * 1000;
  //             choosedMarker = i;
  //             distance = dist.toString() + " Км";
  //           }
  //           markerAboutBuilder(i);
  //           panelContent = markerAbout;
  //           _maxHeight = 300;
  //           panelController.open();
  //         }),
  //       ));
  //       print("marker added!");
  //     }
  //   });
  // }

  void getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }

  @override
  void initState() {
    getDiffMarkers();
    setMapButtons();
    // _getCurrentLocation();
  }

  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      // await showDialog or Show add banners or whatever
      // then
      return true; // return true if the route to be popped
    }

    void onMapCreated(GoogleMapController controller) async {
      setState(() {
        myMapController = controller;
        // _getCurrentLocation();
      });
    }

    firstEnter ? setMenuPanelContent() : print("panel is setted");
    setState(() {
      firstEnter = false;
    });
    // _getCurrentLocation();
    setMapButtons();
    getGeo();
    // getVisitedPlaces();
    getToken();
    // _sendRequestPlaces();
    getDiffMarkers();
    //set my positon

    return WillPopScope(
      child: Material(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.name),
            ),
            body: SlidingUpPanel(
              onPanelClosed: () {
                setState(() {
                  print("panel is closed");
                  setMenuPanelContent();
                });
              },
              controller: panelController,
              borderRadius: radius,
              boxShadow: boxShad,
              minHeight: 60,
              maxHeight: _maxHeight,
              //Panel
              panel: panelContent,
              //MainScreen
              body: Scaffold(
                floatingActionButton: Column(children: listOfFloatButtons),
                body: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomGesturesEnabled: true,
                  // initialCameraPosition: CameraPosition(
                  //   target: LatLng(, position.longitude),
                  //   zoom: zoom,
                  // ),
                  markers: Set<Marker>.of(allMarkers),
                  polylines: Set<Polyline>.of(_polylines.values),
                  mapType: MapType.normal,
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                      zoom: zoom, target: LatLng(widget.lng, widget.ltd)),
                ),
              ),
            )),
      ),
      onWillPop: _willPopCallback,
    );
  }
}
