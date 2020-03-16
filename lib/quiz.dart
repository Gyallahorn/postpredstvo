import 'dart:async';
import 'package:pospredsvto/answer.dart';
import 'package:quiver/async.dart';

import 'package:flutter/material.dart';

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: QuizLo()));
  }
}

class QuizLo extends StatefulWidget {
  @override
  _QuizLoState createState() => _QuizLoState();
}

class _QuizLoState extends State<QuizLo> {
  @override
  int _start = 30;
  int _current = 30;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width;
    @override
    initState() {
      startTimer();
      super.initState();
    }

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                "Вопрос",
                style: TextStyle(color: Colors.black),
              ),
              color: Colors.grey,
              height: 150,
              width: height,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text("Счет:"),
                SizedBox(
                  width: 250,
                ),
                FlatButton(
                  child: CircleAvatar(
                    radius: 46,
                    child: Text("$_current"),
                  ),
                  onPressed: () => {startTimer()},
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(height: 200, width: 500, child: Answers()),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              color: Colors.yellow,
              child: Text("Далее"),
              onPressed: () => {startTimer()},
            )
          ],
        ),
      ),
    );
  }
}
