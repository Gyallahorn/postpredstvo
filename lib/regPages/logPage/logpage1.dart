import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pospredsvto/mainFrame.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LogPage1 extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool log;
  String token;
  @override
  Widget build(BuildContext context) {

    void wrongData() {
      print("wrong email or password");
      showDialog(context:context,builder: (BuildContext context){
        return AlertDialog(title: Text("Ошибка"),content: Text("неверный email или пароль"),actions: <Widget>[
          FlatButton(child: Text("Закрыть"),onPressed: ()=>{
            Navigator.of(context).pop()
          },)
        ],);
      });
    }

    Future<String> _sendRequest(String email, String passwrod) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      token = sharedPreferences.getString("token");
      print(token);

      var jsonResponse;

      var response  = await http.post('http://192.168.0.103:4000/api/user/signin',
          body: {'email':email,'password':passwrod},headers: {
          HttpHeaders.authorizationHeader: "Bearer $token"
          }, );
        print("token is send");
      if(response.statusCode==200) {
        print("good code 200");
        jsonResponse = json.decode(response.body);
        var res = jsonResponse;
        print(jsonResponse["msg"]);
        print("user logged in! "+response.body.toString());

        if(jsonResponse["msg"]=="success"){
          print("logged in");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainFrame()),
          );
        }
        else{
          print(response.toString());
          wrongData();
        }
        return response.body;
      }
      else{
        wrongData();
      }
    }



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
                controller:  emailController,
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
