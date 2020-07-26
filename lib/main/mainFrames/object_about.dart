import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pospredsvto/main/mainFrames/objects.dart';
import 'package:pospredsvto/map/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObjectAbout extends StatefulWidget {
  final int index;
  const ObjectAbout(this.index);
  @override
  _ObjectAboutState createState() => _ObjectAboutState();
}

var diff;
void getDiff() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  diff = sharedPreferences.getInt('dif');
  print(diff);
}

class _ObjectAboutState extends State<ObjectAbout> {
  @override
  Widget build(BuildContext context) {
    // getDiff();
    diff = widget.index;
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
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Text(
                  difficults[widget.index]["name"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      Icon(
                        Icons.play_arrow,
                        size: 15,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Слушать аудио")
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
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      child: Container(
                    child: FlatButton(
                        child: Text(
                      "Скачать",
                      style: TextStyle(color: Colors.white),
                    )),
                    color: Colors.grey,
                    width: 180,
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
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
                          builder: (context) => MapFrame(diff),
                        ),
                      );
                    },
                  )
                ],
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
      ),
    );
  }
}
