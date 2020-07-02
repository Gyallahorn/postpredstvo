import 'package:flutter/material.dart';
import 'package:pospredsvto/main/destinations.dart';
import 'package:pospredsvto/main/mainFrames/ojects_list.dart';
import 'package:pospredsvto/main_scrolls/main_scroll_view.dart';
import 'package:pospredsvto/main_scrolls/redaction_choices.dart';
import 'package:pospredsvto/map/map.dart';

import 'map/choose_difficult.dart';

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
          title: Text("Обзор"),
        ),
        body: TabBarView(children: [
          ObjectList(),
          Center(
            child: Text("Page 2"),
          ),
          Center(
            child: Text("Page 3"),
          ),
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
