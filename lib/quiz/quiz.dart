import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:pospredsvto/quiz/quizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

bool isNotCalled = true;
bool isTapped = false;
bool testEnded = false;
var choosedAnswer = "";
int group = 1;

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

var finalScore = 0;
var questionNumber = 0;
var quiz = new Quizes();
var answersWidgets = List<Widget>();

class _QuizState extends State<Quiz> {
  var color = Colors.grey;

  // init answers buttons
  void answersBuilder() async {
    for (int i = 0; i < quiz.choices[questionNumber].length; i++) {
      answersWidgets.add(GestureDetector(
        onTap: () => setState(() {
          group = i + 1;
          isTapped = true;
          color = Colors.blue;
          choosedAnswer = quiz.choices[questionNumber][i];
          print(i);
        }),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey.shade100,
              child: Row(
                children: <Widget>[
                  Radio(
                    value: i + 1,
                    groupValue: group,
                    onChanged: (T) {
                      print(i);
                      setState(() {
                        print(T);
                        group = T;
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(quiz.choices[questionNumber][i])),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ));
    }
  }

  void setScore() async {
    SharedPreferences score = await SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    score.setString('testScore', finalScore.toString());
    var token = sharedPreferences.getString('token');

    var jsonResponse;
    print("User token:" + token);
    if (token != null) {
      var response = await http.patch(
        urlHost + '/api/user/updateTest',
        body: {"test": finalScore.toString()},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      jsonResponse = json.decode(response.body);
      if (jsonResponse["msg"] == "success") {
        print("Success");
      }
    }
  }

//next question
  void UpdateQuestion() {
    setState(() {
      answersWidgets.removeRange(0, answersWidgets.length);
      isNotCalled = true;
      if (choosedAnswer == quiz.correctAnswers[questionNumber]) {
        print("Correct!");
        finalScore++;
      } else {
        print("Incorrect!");
      }

      if (questionNumber == quiz.quiestions.length - 1) {
        setScore();
        testEnded = true;
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(score: finalScore)));
        questionNumber = 0;
      } else {
        questionNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (testEnded) {
      finalScore = 0;
      testEnded = false;
    }
    answersWidgets.clear();
    answersBuilder();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Material(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    "${questionNumber + 1} из ${quiz.quiestions.length}",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15),
                  child: Text(
                    quiz.quiestions[questionNumber],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 33,
                ),
                Container(
                  height: 292,
                  padding: EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    children: answersWidgets,
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 280,
                    height: 44,
                    child: RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "Далее",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => UpdateQuestion()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Summary extends StatelessWidget {
  final int score;
  var quiz = new Quizes();
  Summary({Key key, @required this.score}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Material(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Результат',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'Всего было отвечено на ${score} вопросов из ${quiz.quiestions.length}'),
                )
              ],
            ),
          ),
        ));
  }
}
