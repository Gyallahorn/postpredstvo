import 'package:flutter/material.dart';
import 'package:pospredsvto/cabinet/cabinet.dart';
import 'package:pospredsvto/main/mainFrames/ojects_list.dart';
import 'package:pospredsvto/quiz/select_quiz.dart';

import 'map/map_test.dart';
import 'navdrawer.dart';

class MainFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  initState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Colors.red,
            ),
          ),
          actions: <Widget>[
            GestureDetector(child: Icon(Icons.search, color: Colors.red)),
            SizedBox(
              width: 10,
            ),
            GestureDetector(child: Icon(Icons.filter_list, color: Colors.red)),
            SizedBox(
              width: 10,
            ),
            GestureDetector(child: Icon(Icons.map, color: Colors.red))
          ],
          title: Text(
            "Обзор",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: TabBarView(children: [
          ObjectList(),
          Center(
            child: MyCabinet(),
          ),
          SelectQuiz(),
          Center(
            child: Text("Page 4"),
          )
        ]),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.card_giftcard,
                color: Colors.red,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.card_giftcard,
                color: Colors.red,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.card_giftcard,
                color: Colors.red,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.card_giftcard,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
