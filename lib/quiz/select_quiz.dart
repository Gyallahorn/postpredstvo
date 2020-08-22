import "package:flutter/material.dart";
import 'package:pospredsvto/quiz/quiz.dart';

class SelectQuiz extends StatelessWidget {
  var testNumber;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Тесты',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: Row(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      testNumber = 0;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Quiz(testNumber)));
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(10)),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 25,
                              ),
                              Flexible(child: Text('Первый тест'))
                            ],
                          ),
                        ),
                      ),
                      height: 135,
                      width: 135,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      testNumber = 1;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Quiz(testNumber)));
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(10)),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 25,
                              ),
                              Center(child: Text('Второй тест'))
                            ],
                          ),
                        ),
                      ),
                      height: 135,
                      width: 135,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                testNumber = 2;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Quiz(testNumber)));
              },
              child: Container(
                decoration: new BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.all(const Radius.circular(10)),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Center(child: Text('Третий тест'))
                      ],
                    ),
                  ),
                ),
                height: 135,
                width: 135,
              ),
            ),
          )
        ],
      ),
    );
  }
}
