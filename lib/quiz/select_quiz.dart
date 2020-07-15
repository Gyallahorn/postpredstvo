import "package:flutter/material.dart";
import 'package:pospredsvto/quiz/quiz.dart';

class SelectQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
SizedBox(height: 20,),
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
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Quiz()));
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
                        Text('%'),
                        SizedBox(
                          height: 25,
                        ),
                        Text('Название первого теста')
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
