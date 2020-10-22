import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:pospredsvto/cabinet/cabinet_edit.dart';
import 'package:pospredsvto/cabinet/components/visited_routes.dart';
import 'package:pospredsvto/map/marker_list.dart';
import 'package:pospredsvto/models/UserData.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyCabinet extends StatefulWidget {
  @override
  _MyCabinetState createState() => _MyCabinetState();
}

class _MyCabinetState extends State<MyCabinet> {
  File _image;
  var testScore = "0";
  var markerList = MarkerList();
  var markersList;
  var listOfPlaces = List<Widget>();
  var profileGetted = false;
  var token;
  var imagePath;
  int vp;
  var user;
  var name = "Имя пользователя";
  var city = "Город";
  var test;
  // getStringValue() async {
  //   SharedPreferences score = await SharedPreferences.getInstance();
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String scoreValue = score.getString('testScore') ?? "0";
  //   imagePath = sharedPreferences.getString('image');
  //   token = sharedPreferences.getString('token');
  //   name = sharedPreferences.getString('name');
  //   city = sharedPreferences.getString('city');
  //   vp = sharedPreferences.getInt('vp');

  //   print(city);
  //   setState(() {
  //     city = city;
  //     name = name;
  //     testScore = scoreValue.toString();
  //     _image = File(imagePath);
  //   });
  //   print(scoreValue.toString() + " score");
  //   print(testScore.toString() + "test score");
  // }

  @override
  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    final response = await http.get(urlHost + getProfile, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final userData =
          userDataFromJson(convert.utf8.decode(response.bodyBytes));
      setState(() {
        user = userData;
        profileGetted = true;
        if (user.user.test == null) {
          test = 0;
        }
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget build(BuildContext context) {
    // getStringValue();
    if (!profileGetted) {
      fetchUserData();
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
                      child: _image == null
                          ? CircleAvatar(
                              backgroundColor: Colors.blue,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(_image),
                            )),
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
                        Text(user.user.lng.length.toString()),
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
                        Text(test.toString()),
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
                height: 20,
              ),
              SizedBox(
                height: 300,
                child: VisitedRoutes(),
              )
            ]),
          )
        ],
      ),
    );
  }
}
