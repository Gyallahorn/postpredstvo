import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'object_about.dart';

class Difficult {
  final int id;
  final String difficult;
  final String difficult_name;
  final String name;
  final String long;
  final String link;
  Difficult(
      {this.id,
      this.difficult,
      this.difficult_name,
      this.name,
      this.long,
      this.link});
  factory Difficult.fromJson(Map<String, dynamic> json) {
    return Difficult(
      id: json['id'],
      difficult: json['difficult'],
      difficult_name: json['difficult_name'],
      name: json['name'],
      long: json['long'],
      link: json['link'],
    );
  }
}

Future<List<Difficult>> fetchDifficulties() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  print("User token:" + token);

  final response = await http.get(
    urlHost + '/api/user/getDifficulties/',
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return compute(parseDifficults, response.body);
  } else {
    throw Exception('Failed to load post');
  }
}

List<Difficult> parseDifficults(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Difficult>((json) => Difficult.fromJson(json)).toList();
}

class ObjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyObjectList(),
    );
  }
}

class MyObjectList extends StatefulWidget {
  @override
  _MyObjectListState createState() => _MyObjectListState();
}

class _MyObjectListState extends State<MyObjectList> {
  var listOfObjects = List<Widget>();
  var jsonResponse;
  var token;
  List<dynamic> list;
  get http => null;

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
        future: fetchDifficulties(),
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
                    ? DifficultsList(
                        difficults: snapshot.data,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
          }
        });

    return new Material(
      child: futureBuilder,
    );
  }
}

class DifficultsList extends StatelessWidget {
  final List<Difficult> difficults;
  DifficultsList({Key key, this.difficults}) : super(key: key);

  // void setDiff(int index) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setInt('dif', index);
  //   print("choosed:" + index.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: difficults.length,
      itemBuilder: (BuildContext context, int index) {
        return (GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ObjectAbout(difficults[index].difficult_name),
              ),
            ),
          },
          child: Column(children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(difficults[index].link.toString()),
                    fit: BoxFit.fitWidth),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.near_me,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 115,
                    child: Text(
                      difficults[index].difficult.toString() +
                          " " +
                          difficults[index].long.toString(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    radius: 2.5,
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Пеший тур"),
                  SizedBox(
                    width: 110,
                  ),
                  VerticalDivider(),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text("4.9"),
                        RatingBar.readOnly(
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.red,
                          halfFilledIcon: Icons.star_half,
                          isHalfAllowed: true,
                          size: 10,
                          initialRating: 4.9,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("15"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ]),
        ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }
}
