import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pospredsvto/main/mainFrames/objects.dart';
import 'package:pospredsvto/map/map.dart';
import 'package:pospredsvto/map/marker_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObjectAbout extends StatefulWidget {
  final int index;
  const ObjectAbout(this.index);
  @override
  _ObjectAboutState createState() => _ObjectAboutState();
}

AudioPlayer audioPlayer;
AudioCache audioCache;
var markerList = MarkerList();
var diffOfList;
var diff;
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
  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
    });
  }

  initPlayer() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

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
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    // getDiff();
    diff = widget.index;
    switch (widget.index) {
      case 0:
        {
          diffOfList = markerList.easyMarkersList;
          break;
        }
      case 1:
        {
          diffOfList = markerList.normalMarkersList;
          break;
        }
      case 3:
        {
          diffOfList = markerList.hardMarkersList;
          break;
        }
    }
    print(diffOfList.length);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
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
          itemCount: diffOfList.length,
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
                          diffOfList[index]["name"],
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
                                  difficults[widget.index]["link"].toString()),
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
                        )),
                        color: Colors.red,
                        width: 180,
                      ),
                      onTap: () {
                        // Write func
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MapFrame(diff, index, position),
                          ),
                        );
                      },
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
      ),
    );
  }
}
