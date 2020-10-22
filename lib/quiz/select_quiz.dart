import "package:flutter/material.dart";

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:pospredsvto/models/Questions.dart';
import 'package:pospredsvto/network/url_helper.dart';

import 'package:pospredsvto/quiz/quiz.dart';

class SelectQuiz extends StatefulWidget {
  @override
  _SelectQuizState createState() => _SelectQuizState();
}

class _SelectQuizState extends State<SelectQuiz> {
  var testNumber;
  var tests;
  bool loading = true;
  fetchTestsData() async {
    final response = await http.get(urlHost + getTests);
    if (response != null) {
      final testData = testFromJson(convert.utf8.decode(response.bodyBytes));
      setState(() {
        loading = false;

        tests = testData;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchTestsData();
    return Material(
      child: !loading
          ? ListView.separated(
              itemBuilder: (BuildContext buildContext, int index) {
                return Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      testNumber = 0;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Quiz(index)));
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
                              Flexible(
                                  child: Text(tests[index].name.toString()))
                            ],
                          ),
                        ),
                      ),
                      height: 135,
                      width: 350,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: tests.length)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
