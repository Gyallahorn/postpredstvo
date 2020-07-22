import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pospredsvto/mainFrame.dart';
import 'package:pospredsvto/regPages/logPage/logpage1.dart';
import 'package:pospredsvto/regPages/regPage/regpage2.dart';
import 'package:http/http.dart' as http;
import 'package:pospredsvto/regPages/regPage/regpage3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage1 extends StatefulWidget {
  @override
  _RegPage1State createState() => _RegPage1State();
}

class _RegPage1State extends State<RegPage1> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void wrongData() {
    print("wrong email or password");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ошибка"),
            content: Text("неверный email или пароль"),
            actions: <Widget>[
              FlatButton(
                child: Text("Закрыть"),
                onPressed: () => {Navigator.of(context).pop()},
              )
            ],
          );
        });
  }

  var _status;

  var _body;
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> _sendRequest(String email, String passwrod) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse;
    var response = await http.post('http://192.168.1.38:4000/api/user/signup',
        body: {'email': email, 'password': passwrod});

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      var res = jsonResponse;

      if (jsonResponse != null) {
        sharedPreferences.setString("email", email);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegPage2()),
        );
      }
      print("user registered! " + response.body.toString());
      sharedPreferences.setString("email", email);
      return response.body;
    } else {
      print("something went wrong");
      wrongData();
      print(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Text('Назад', style: TextStyle(color: Colors.grey))),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(65, 0, 0, 0),
            child: Text(
              'Регистрация',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        actions: <Widget>[
          Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: InkWell(
                  onTap: () {
                    _sendRequest(emailController.text, passwordController.text);
                  },
                  child: Text('Далее',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
            ),
          ])
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                        child: Text('Почта')),
                    border: UnderlineInputBorder(),
                    hintText: 'example@gmail.com'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                        child: Text('Пароль')),
                    border: UnderlineInputBorder(),
                    hintText: 'Мин 8 символов'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
