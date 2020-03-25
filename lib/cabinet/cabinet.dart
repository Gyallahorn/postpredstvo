import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String testScore = " ";

class MyCabinet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getStringValue() async {
      SharedPreferences scores = await SharedPreferences.getInstance();
      String scoreValue = scores.getString('testScore') ?? "0";
      testScore = scoreValue;
      return scoreValue;
    }

    getStringValue();
    print(testScore + " score");
    return Material(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            // padding: EdgeInsets.only(left: 10),
            child: Text(
              'Профиль',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 180,
            child: Image(
              image: NetworkImage(
                  'http://playminigames.ru/content/gameimagecontent/quake3_1_2c7a197d4f97420cba0cb3f8163716c8.jpg'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Divider(
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  child: Divider(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'Вам необходимо пройти все меята памяти, затем выполнить тесты, после чего Вы будете приглашены на очный этап квеста а Постоянном Представительстве Республики Саха(Якутия) При Президенте РФ',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 180,
            child: Divider(
              color: Colors.blue,
            ),
          ),
          Container(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 90),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('0/9'),
                        Text(
                          'Мест',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 170,
                    ),
                    Column(
                      children: <Widget>[
                        Text(testScore),
                        Text(
                          'Тест',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(right: 205),
                child: Column(
                  children: <Widget>[
                    Text('0/5'),
                    Text(
                      'Мест',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(right: 205),
                child: Column(
                  children: <Widget>[
                    Text('0/5'),
                    Text(
                      'Мест',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
