import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pospredsvto/mainFrame.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LogPage1 extends StatefulWidget {
  @override
  _LogPage1State createState() => _LogPage1State();
}

class _LogPage1State extends State<LogPage1> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  String email;

  bool log;

  String token;

  bool _onLoad = false;

  @override
  Widget build(BuildContext context) {
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

    void confirmEmail() {
      print("pls confirm your email");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ошибка"),
              content: Text("Пожалуйста потвердите вашу почту"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Закрыть"),
                  onPressed: () => {Navigator.of(context).pop()},
                )
              ],
            );
          });
    }

    void checkEmailInStorage() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (sharedPreferences.getString('email') != null) {
        email = sharedPreferences.getString('email');
        emailController.text = email;
        print(email);
      }
    }

    Future<String> _sendRequest(String email, String passwrod) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var jsonResponse;

      var response = await http.post(
        urlHost + '/api/user/signin',
        body: {'email': email, 'password': passwrod},
      );
      jsonResponse = json.decode(response.body);

      if (jsonResponse["msg"] == "success") {
        print("good code 200");

        var res = jsonResponse;
        print(jsonResponse["msg"]);
        print("user logged in! token:" + jsonResponse["token"]);
        sharedPreferences.setString('token', jsonResponse["token"]);
        print("logged in");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainFrame()),
        );
      }
      if (jsonResponse["msg"] == "confirm your email") {
        confirmEmail();
        _onLoad = false;
      }
      if (jsonResponse["msg"] == "wrong password or email") {
        print(response.toString());
        wrongData();
        _onLoad = false;
      }
    }

    checkEmailInStorage();
    emailController.text = email;
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
            padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
            child: Text(
              'Вход',
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
                    setState(() {
                      _onLoad = true;
                    });
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
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: _onLoad ? CircularProgressIndicator() : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
