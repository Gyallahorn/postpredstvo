import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pospredsvto/cabinet/cabinet.dart';
import 'package:pospredsvto/quiz/select_quiz.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

import 'marker_list.dart';

class MapFrame extends StatefulWidget {
  @override
  _MapFrameState createState() => _MapFrameState();
}

String googleApiKey = 'AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ';
List<Map<String, dynamic>> markers = [];

GoogleMapPolyline googleMapPolyline =
    new GoogleMapPolyline(apiKey: "AIzaSyD1jTuV-6U9jr8R9K91sgibrZ4ETpT09UQ");

class _MapFrameState extends State<MapFrame> {
  int i = 0;
  var dist;
  var distM;
  bool listCalled = false;
  bool menuPressed = false;
  bool profilePressed = false;
  bool testPressed = false;
  var panelContent;
  var menuPanelContent;
  var distance = "выберите маркер";

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
  var listOfFloatButtons = List<Widget>();
  var makeRouteButton0;
  var choosedMarker;
  var makeRouteButtonCancel;
  var makeRouteButton2;
  var makeRouteButton1;
  var makeRoutePanel;
  var markerAbout;
  bool routeButtonPressed = false;

  //Map
  GoogleMapController myMapController;
  // final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  static Position position;
  Widget _child;
  double zoom = 12;
  Position csreenPos;
  PanelController panelController = new PanelController();
  var markList;
  LatLng startPoint;

//get my position
  void getGeo() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

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

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: _coordinates,
        width: 10);
    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
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
                zoom: 15,
              ),
            ),
          );
          // makeRouteCancelButtonBuilder(i);
          makeRouteButton1Builder(i, distM);
          markerAboutBuilder(i);
          print("builded");
          panelContent = markerAbout;
          if (distM < 100) {
            var nameOfDestPoint = markList.markersList[choosedMarker]["name"];
            print('im near');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: AutoSizeText(
                        'Вы дошли до пункта назначения $nameOfDestPoint '),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Понятно'))
                    ],
                  );
                });
          }
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
                    Container(
                      width: 300,
                      child: AutoSizeText(
                        markList.markersList[i]["name"],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: 300,
                      child: AutoSizeText(
                        markList.markersList[i]["street"],
                        maxLines: 2,
                        style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      ),
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

  // void routeBuilder(int i, makeRouteButton, makeRouteButton1) {
  //   setState(() {
  //     print("routeBuilder called");
  //     dist = distanceBetwee(
  //         markList.markersList[i]["lng"],
  //         markList.markersList[i]["ltd"],
  //         position.latitude,
  //         position.longitude);
  //     if (dist < 1.0) {
  //       dist = dist * 1000;
  //       dist = dist.round();
  //       distance = dist.toString() + " м";
  //     } else {
  //       dist = dist.round();
  //       distance = dist.toString() + " Км";
  //     }
  //   });
  // }

  double distanceBetwee(lat1, lon1, lat2, lon2) {
    var pi = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * pi) / 2 +
        cos(lat1 * pi) * cos(lat2 * pi) * (1 - cos((lon2 - lon1) * pi)) / 2;
    return 12742 * asin(sqrt(a));
  }

  markerAboutBuilder(int i) {
    setState(() {
      print("markerAboutBuilder called");
      markerAbout = Column(
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
                      width: 300,
                      padding: EdgeInsets.only(left: 10),
                      child: AutoSizeText(
                        markList.markersList[i]["name"],
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
                        markList.markersList[i]["street"],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 17,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: (!routeButtonPressed) ? makeRouteButton0 : makeRouteButton2,
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
            child: AutoSizeText(
              markList.markersList[i]["desc"],
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          )
        ],
      );
    });
  }

  makeRouteButton1Builder(int i, int distM) {
    setState(() {
      print("OH WAY" + distM.toString());
      if (distM > 100) {
        makeRouteButton0 = Container(
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
                    routeButtonPressed = true;
                    panelController.close();
                    getSomePoints(markList.markersList[i]["lng"],
                        markList.markersList[i]["ltd"]);
                  })),
        );
      } else {
        makeRouteButton0 = Container(
          width: 380,
          height: 60,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 17,
              ),
              Icon(
                Icons.directions_walk,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'На месте',
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
              SizedBox(
                width: 17,
              ),
              Container(
                height: 60,
                width: 220,
                child: RaisedButton(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.clear,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Включить AR",
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('Work In Progress!'),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: new Text('ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        })),
              ),
            ],
          ),
        );
      }
      makeRouteButton2 = Container(
        width: 380,
        height: 60,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 17,
            ),
            Icon(
              Icons.directions_walk,
              color: Colors.blue,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'В пути',
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            SizedBox(
              width: 17,
            ),
            Container(
              height: 60,
              width: 250,
              child: RaisedButton(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.clear,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Отменить маршрут",
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
                        routeButtonPressed = false;
                        panelController.close();
                        _polylines.clear();
                      })),
            ),
          ],
        ),
      );
    });
  }

  // makeRouteCancelButtonBuilder(int i) {
  //   setState(() {
  //     print('called makeCancel');

  //     initState();
  //     panelContent = markerAbout;
  //     makeRouteButton0 = makeRouteButton2;
  //   });
  // }

  setMapButtons() {
    setState(() {
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
            listOfFloatButtons = listOfFloatButtons1;
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
    });
  }

  setFloatingButtons() {
    setState(() {
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
            panelContent = SelectQuiz();
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
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              listOfFloatButtons = listOfFloatButtons2;
            });
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue,
            ),
          ),
        )
      ];
    });
  }

  setMenuPanelContent() {
    setState(() {
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
    });
  }

  addMarkers() {
    setState(() {
      for (int i = 0; i < markList.markersList.length; i++) {
        allMarkers.add(Marker(
          markerId: MarkerId(i.toString()),
          draggable: false,
          position: LatLng(
              markList.markersList[i]["lng"], markList.markersList[i]["ltd"]),
          onTap: () => setState(() {
            //calc distance
            dist = distanceBetwee(
                markList.markersList[i]["lng"],
                markList.markersList[i]["ltd"],
                position.latitude,
                position.longitude);
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
            makeRouteButton1Builder(i, distM);

            // routeBuilder(i, makeRouteButton2, makeRouteButton1);
            markerAboutBuilder(i);
            panelContent = markerAbout;
            panelController.open();
          }),
        ));
      }
    });
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
    });
  }

  @override
  void initState() {
    getGeo();
    getCurrentLocation();

    markList = new MarkerList();
    setMapButtons();
    setFloatingButtons();
    setMenuPanelContent();
    listOfFloatButtons = listOfFloatButtons2;
    panelContent = menuPanelContent;
    addMarkers();
    super.initState();
  }

  Widget build(BuildContext context) {
    getGeo();

    void onMapCreated(GoogleMapController controller) async {
      setState(() {
        myMapController = controller;
      });
    }

    if (!listCalled) {
      listBuilder();
      listCalled = true;
    } else {
      print('listAlredyCalled');
    }
    if (!menuPressed) {
      //set my positon
      getCurrentLocation();
      startPoint = LatLng(position.latitude, position.longitude);

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
            floatingActionButton: Column(children: listOfFloatButtons),
            body: GoogleMap(
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: startPoint,
                zoom: zoom,
              ),
              markers: Set<Marker>.of(allMarkers),
              polylines: Set<Polyline>.of(_polylines.values),
              mapType: MapType.normal,
              onMapCreated: onMapCreated,
            ),
          ),
        )),
      );
    }
  }
}
