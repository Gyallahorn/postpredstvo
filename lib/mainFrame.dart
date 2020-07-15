import 'package:flutter/material.dart';
import 'package:pospredsvto/main/mainFrames/ojects_list.dart';
import 'package:pospredsvto/quiz/select_quiz.dart';

import 'map/map_test.dart';

class MainFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  initState();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(child: Icon(Icons.menu,color: Colors.red,),),
          actions: <Widget>[GestureDetector(child:Icon(Icons.search,color:Colors.red)),SizedBox(width: 10,)
            ,GestureDetector(child:Icon(Icons.filter_list,color:Colors.red)),SizedBox(width: 10,)
            ,GestureDetector(child:Icon(Icons.map,color:Colors.red))],
          title: Text("Обзор",style: TextStyle(color: Colors.black),),
        ),
        body: TabBarView(children: [
          ObjectList(),
          Center(
            child: Text("Page 3"),
          ),SelectQuiz(),
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
