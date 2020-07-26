import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pospredsvto/map/marker_list.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyCabinetEdit extends StatefulWidget {
  @override
  _MyCabinetEditState createState() => _MyCabinetEditState();
}

class _MyCabinetEditState extends State<MyCabinetEdit> {
  File _image;
  final picker = ImagePicker();
  var nameEditController = TextEditingController();
  var cityEditingController = TextEditingController();
  var testScore = "0";
  var markerList = MarkerList();
  var markersList;
  var listOfPlaces = List<Widget>();
  var token;
  var infoSaved = false;
  bool _onLoad = false;

  getStringValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }

  saveUserData(String name, String city) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('name', name);
    sharedPreferences.setString('city', city);
    Navigator.pop(context);
  }

  fillBothFields() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ошибка"),
            content: Text("Пожалуйста введите оба поля"),
            actions: <Widget>[
              FlatButton(
                child: Text("Закрыть"),
                onPressed: () => {Navigator.of(context).pop()},
              )
            ],
          );
        });
  }

  networkTrouble() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ошибка"),
            content: Text("Неполадки с интернетом пожалуйста повторите позже"),
            actions: <Widget>[
              FlatButton(
                child: Text("Закрыть"),
                onPressed: () => {Navigator.of(context).pop()},
              )
            ],
          );
        });
  }

  Future<String> _sendRequestEditProfile() async {
    var jsonResponse;
    print("User token:" + token);
    var name = nameEditController.text;
    var city = cityEditingController.text;
    if (name != "" && city != "") {
      print("both fields is ok");
      if (token != null) {
        var response = await http.post(
          urlHost + '/api/user/editProfile',
          body: {"city": city, "name": name},
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        jsonResponse = json.decode(response.body);
        if (jsonResponse["msg"] == "success") {
          saveUserData(name, city);
        } else {
          networkTrouble();
          setState(() {
            _onLoad = false;
          });
        }
      }
    } else {
      print("fill field ples");
      setState(() {
        _onLoad = false;
      });
      fillBothFields();
    }
  }

  cameraConnect() async {
    print('Picker is Called');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    sharedPreferences.setString('image', pickedFile.path);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    getStringValue();
    return Material(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView(children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 165,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 86,
                        height: 86,
                        child: _image == null
                            ? Center(child: Text('Фото отсутвует'))
                            : CircleAvatar(
                                backgroundImage: FileImage(_image),
                              ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.add_a_photo),
                        onPressed: cameraConnect,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                    width: 81,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: TextField(
                  controller: nameEditController,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                          child: Text('Имя')),
                      border: UnderlineInputBorder(),
                      hintText: 'Имя пользовотеля'),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Center(
                child: TextField(
                  controller: cityEditingController,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                          child: Text('Город')),
                      border: UnderlineInputBorder(),
                      hintText: ''),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: _onLoad
                    ? CircularProgressIndicator()
                    : Container(
                        width: 120,
                        child: FlatButton(
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _onLoad = true;
                              });
                              _sendRequestEditProfile();
                            },
                            child: Text("Сохранить")),
                      ),
              ),
              SizedBox(
                height: 29,
              )
            ]),
          )
        ],
      ),
    );
  }
}
