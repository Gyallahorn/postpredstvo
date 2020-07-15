import 'package:flutter/material.dart';
import 'package:pospredsvto/regPages/RegPage/regpage1.dart';
import 'package:pospredsvto/regPages/logPage/logpage1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  SharedPreferences sharedPreferences ;

  void signUp(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 137, 0, 0),
          child: Center(
              child: Image.asset(
            'graphics/logotype.png',
            width: 150,
            height: 150,
          )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Center(
              child: Text(
            'Виртуальная Якутия',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProDisplay-Bold'),
          )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 116, 0, 0),
          child: Center(
            child: Container(
                width: 226,
                height: 44,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegPage1()),
                    );
                  },
                  child: Text(
                    'Регистрация',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'SFProDisplay-Bold'),
                  ),
                  color: Colors.blue,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Center(
            child: Container(
                width: 226,
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue)),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogPage1()),
                    );
                  },
                  child: Text(
                    'Вход',
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'SFProDisplay-Bold'),
                  ),
                  color: Colors.white,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Center(
              child: Container(
                  width: 226,
                  height: 44,
                  child: Text(
                    'Политика конфиденциальности \n и лицензионное соглашение',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontFamily: 'SFProDisplay-Bold'),
                  ))),
        ),
      ],
    ));
  }
}
