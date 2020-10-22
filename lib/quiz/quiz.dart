import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pospredsvto/mainFrame.dart';
import 'package:pospredsvto/models/Questions.dart';
import 'package:pospredsvto/network/url_helper.dart';
import 'package:pospredsvto/quiz/quizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

bool isNotCalled = true;
bool isTapped = false;
bool testEnded = false;
var choosedAnswer = "";
int group = 1;

class Quiz extends StatefulWidget {
  final int testIndex;
  const Quiz(this.testIndex);
  @override
  _QuizState createState() => _QuizState();
}

var finalScore = 0;
var questionNumber = 0;
var quiz;
int count;
var correctAnswers;
var answersWidgets = List<Widget>();
bool loading = true;
var finalQuestion = false;

class _QuizState extends State<Quiz> {
  var color = Colors.grey;
  @override
  fetchTestsData() async {
    final response = await http.get(urlHost + getTests);

    if (response != null) {
      final testsData = testFromJson(convert.utf8.decode(response.bodyBytes));

      setState(() {
        loading = false;

        quiz = testsData;
        count = testsData[widget.testIndex].test.length - 1;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  // init answers buttons
  void answersBuilder() async {
    for (int i = 0;
        i < quiz[widget.testIndex].test[questionNumber].length - 1;
        i++) {
      answersWidgets.add(GestureDetector(
        onTap: () => setState(() {
          group = i + 1;
          isTapped = true;
          color = Colors.blue;
          choosedAnswer = quiz[widget.testIndex].test[questionNumber][i + 1];
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
                      child: Text(
                          quiz[widget.testIndex].test[questionNumber][i + 1])),
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

  void setScore(int score, String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var jsonResponse;

    print("User token:" + token);

    if (token != null) {
      var response = await http.post(
        urlHost + '/api/quiz/updatetest',
        body: {"score": '$score', "name": '$name'},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      jsonResponse = json.decode(response.body);
      if (jsonResponse["message"] == "done!") {
        print("Success");
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(
                      score: score,
                      count: count,
                    )));
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    testEnded = true;
    questionNumber = 0;
    finalQuestion = false;
    super.dispose();
  }

//next question
  void UpdateQuestion() {
    setState(() {
      answersWidgets.removeRange(0, answersWidgets.length);
      isNotCalled = true;
      print("rig " +
          quiz[widget.testIndex].test[quiz[widget.testIndex].test.length - 1]
              [questionNumber]);
      print("N%" + questionNumber.toString());
      print("Choosed " + choosedAnswer);
      if (choosedAnswer ==
          quiz[widget.testIndex].test[quiz[widget.testIndex].test.length - 1]
              [questionNumber]) {
        print("Correct!");
        finalScore++;
      } else {
        print("Incorrect!");
      }

      if (questionNumber == quiz[widget.testIndex].test.length - 2) {
        setState(() {
          finalQuestion = true;
        });
        setScore(finalScore, quiz[widget.testIndex].name);
      } else {
        questionNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchTestsData();
    if (testEnded) {
      finalScore = 0;
      testEnded = false;
    }
    answersWidgets.clear();
    answersBuilder();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: !loading
            ? Material(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${questionNumber + 1} из ${quiz[widget.testIndex].test.length - 1}",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15),
                        child: Text(
                          quiz[widget.testIndex].test[questionNumber][0],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      Container(
                        height: 365,
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
                        child: !finalQuestion
                            ? Container(
                                width: 280,
                                height: 44,
                                child: RaisedButton(
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                    ),
                                    child: Text(
                                      "Далее",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => UpdateQuestion()),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class Summary extends StatelessWidget {
  final int score;
  final int count;
  Summary({Key key, @required this.score, this.count}) : super(key: key);
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
                      'Всего было отвечено на ${score} вопросов из ${count}'),
                ),
                SizedBox(
                  height: 50,
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
                          "Ок",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainFrame()),
                            (route) => false)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
