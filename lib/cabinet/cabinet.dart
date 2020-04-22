import 'package:flutter/material.dart';
import 'package:pospredsvto/map/marker_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCabinet extends StatefulWidget {
  @override
  _MyCabinetState createState() => _MyCabinetState();
}

class _MyCabinetState extends State<MyCabinet> {
  var testScore = "0";
  var markerList = MarkerList();
  var markersList;
  var listOfPlaces = List<Widget>();
  getStringValue() async {
    SharedPreferences score = await SharedPreferences.getInstance();
    String scoreValue = score.getString('testScore') ?? "0";
    print(scoreValue.toString() + "1 score");
    setState(() {
      testScore = scoreValue;
    });
    print(testScore.toString() + "3 score");
  }

  void listBuilder() async {
    for (int i = 0; i < markersList.length; i++) {
      listOfPlaces.add(GestureDetector(
        onTap: () => {},
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
                    Text(
                      markersList[i]["name"],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      markersList[i]["street"],
                      style: TextStyle(fontSize: 13, color: Colors.grey[400]),
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

  @override
  void initState() {
    markersList = markerList.markersList;

    getStringValue();

    listBuilder();

    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
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
                  Icon(Icons.edit)
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  'Имя Пользовотеля',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
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
                      Text(
                        'Город',
                        style: TextStyle(fontSize: 15),
                      )
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
