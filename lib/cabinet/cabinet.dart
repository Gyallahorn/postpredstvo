import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pospredsvto/cabinet/cabinet_edit.dart';
import 'package:pospredsvto/map/marker_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyCabinet extends StatefulWidget {
  @override
  _MyCabinetState createState() => _MyCabinetState();
}

class _MyCabinetState extends State<MyCabinet> {
  var testScore = "0";
  var markerList = MarkerList();
  var markersList;
  var listOfPlaces = List<Widget>();
  var profileGetted = false;
  var token;

  var name = "Имя пользователя";
  var city = "Город";
  getStringValue() async {
    SharedPreferences score = await SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String scoreValue = score.getString('testScore') ?? "0";

    token = sharedPreferences.getString('token');
    name = sharedPreferences.getString('name');
    city = sharedPreferences.getString('city');
    print(city);
    setState(() {
      city = city;
      name = name;
      testScore = scoreValue.toString();
    });
    print(scoreValue.toString() + " score");
    print(testScore.toString() + "test score");
  }

  @override
  Future<String> _sendRequestProfile() async {
    var jsonResponse;
    print("User token:" + token);
    if (token != null) {
      var response = await http.get(
        'http://192.168.1.38:4000/api/user/getTestResults',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      profileGetted = true;
      jsonResponse = json.decode(response.body);
      if (jsonResponse["msg"] == "success") {
        print("NAME!" + jsonResponse["user"].name);
      }
    }
  }

  Widget build(BuildContext context) {
    getStringValue();
    if (!profileGetted) {
      _sendRequestProfile();
    }
    return Material(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 17,
          ),
          Expanded(
            child: ListView(children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 165,
                  ),
                  Container(
                    width: 86,
                    height: 86,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                    width: 81,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCabinetEdit()));
                      },
                      child: Icon(Icons.edit))
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Center(child: Text(name)),
              SizedBox(
                height: 17,
              ),
              Container(
                  padding: EdgeInsets.only(left: 165),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      Text(city),
                    ],
                  )),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.only(left: 110),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('0'),
                        SizedBox(
                          height: 6,
                        ),
                        Text('Задания')
                      ],
                    ),
                    SizedBox(
                      width: 76,
                    ),
                    Column(
                      children: <Widget>[
                        Text(testScore),
                        SizedBox(
                          height: 6,
                        ),
                        Text('Тесты')
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: Text(
                  'Выполненные задания:',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
