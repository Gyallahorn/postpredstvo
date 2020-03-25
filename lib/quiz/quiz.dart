import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pospredsvto/quiz/quizes.dart';

bool isNotCalled = true;
bool isTapped = false;
var choosedAnswer = "";

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
      print("kek");
      answersWidgets.add(GestureDetector(
        onTap: () => setState(() {
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
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.grey,
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
        questionNumber = 0;
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(score: finalScore)));
      } else {
        questionNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isNotCalled) {
      answersBuilder();
      setState(() {
        isNotCalled = false;
      });
    } else {
      print("is already exist");
    }
    return Material(
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
              height: 250,
              padding: EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: answersWidgets,
              ),
            ),
            SizedBox(
              height: 94,
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
