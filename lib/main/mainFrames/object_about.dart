import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pospredsvto/map/map.dart';
import 'package:pospredsvto/map/marker_list.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Route {
  final int id;
  final double lng;
  final double ltd;
  final String name;
  final String street;
  final String img;
  final String desc;
  final String difficult;
  Route(
      {this.id,
      this.lng,
      this.ltd,
      this.name,
      this.street,
      this.img,
      this.desc,
      this.difficult});
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      lng: json['lng'],
      ltd: json['ltd'],
      name: json['name'],
      street: json['street'],
      img: json['img'],
      desc: json['desc'],
      difficult: json['difficult'],
    );
  }
}

Future<List<Route>> fetchRoutes(String difficult) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  print("User token:" + token);

  final response = await http.get(
    urlHost + '/api/routes/getRoutes/' + '${difficult}',
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    // var data = json.decode(response.body);
    // var list = data.map<Route>((json) => Route.fromJson(json)).toList();

    return compute(parseRoutes, response.body);
  } else {
    throw Exception('Failed to load post');
  }
}

List<Route> parseRoutes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Route>((json) => Route.fromJson(json)).toList();
}

class ObjectAbout extends StatefulWidget {
  final String difficult;
  const ObjectAbout(this.difficult);
  @override
  _ObjectAboutState createState() => _ObjectAboutState();
}

AudioPlayer audioPlayer;
AudioCache audioCache;
var markerList = MarkerList();
var diffOfList;
var diff;
var lng = [];
var ltd = [];
bool _playing = false;
Position position;
Duration _duration = Duration();
Duration _position = Duration();
void getDiff() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  diff = sharedPreferences.getInt('dif');
  print(diff);
}

class _ObjectAboutState extends State<ObjectAbout> {
  // void getCurrentLocation() async {
  //   Position res = await Geolocator().getCurrentPosition();
  //   setState(() {
  //     position = res;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
        future: fetchRoutes(widget.difficult),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return new Text('Error:${snapshot.error}');
              } else
                return snapshot.hasData
                    ? RoutesList(
                        routes: snapshot.data,
                      )
                    : Center(child: CircularProgressIndicator());
          }
        });
    return new Material(
      child: futureBuilder,
    );
  }
}

class RoutesList extends StatefulWidget {
  final List<Route> routes;
  RoutesList({Key key, @required this.routes}) : super(key: key);

  @override
  _RoutesListState createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  @override
  void dispose() {
    audioPlayer.stop();
  }

  Future<String> _getVisitedRoutes() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    print("User token:" + token);
    var jsonResponse;
    final response = await http.get(
      urlHost + '/api/user/getProfile',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    jsonResponse = json.decode(response.body);
    if (jsonResponse["msg"] == "success") {
      lng = jsonResponse["user"]["lng"];
      ltd = jsonResponse["user"]["ltd"];
      print(ltd);
      print("success");
    } else {
      print("error something went wrong");
    }
  }

  removeVisitedPlaces() {
    for (int i = 0; i < widget.routes.length; i++) {
      print(widget.routes[i].lng);
      for (int j = 0; j < lng.length; j++) {
        if (widget.routes[i].lng == lng[j] && widget.routes[i].ltd == ltd[j]) {
          print("visited" + i.toString());
          widget.routes.removeAt(i);
        }
      }
    }
  }

  initPlayer() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    // ignore: deprecated_member_use
    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    // ignore: deprecated_member_use
    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  String localPathFile;

  play() async {
    audioCache.play('11.mp3');
    setState(() {
      _playing = true;
    });
  }

  pause() async {
    audioPlayer.pause();
    setState(() {
      _playing = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getVisitedRoutes();
    removeVisitedPlaces();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Тур",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.routes.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        widget.routes[index].name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Text("Kirill.O", style: TextStyle(fontSize: 15)),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Пеший тур",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    Icon(
                      Icons.access_time,
                      size: 10,
                    ),
                    Text("1h 20m (5,3km)"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          !_playing
                              ? Icon(
                                  Icons.play_arrow,
                                  size: 15,
                                )
                              : Icon(Icons.pause, size: 15),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            child: Text("Слушать аудио"),
                            onTap: () {
                              if (!_playing) {
                                play();
                              } else {
                                pause();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      height: 320,
                      width: 360,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.routes[index].img.toString()),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: GestureDetector(
                    child: Container(
                      child: FlatButton(
                        child: Text(
                          "Начать",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapFrame(
                                  diff,
                                  index,
                                  widget.routes[index].lng,
                                  widget.routes[index].ltd,
                                  widget.routes[index].name),
                            ),
                          );
                        },
                      ),
                      color: Colors.red,
                      width: 180,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10,
          );
        },
      ),
    );
    ;
  }
}
