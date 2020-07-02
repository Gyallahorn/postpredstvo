import 'package:flutter/material.dart';
import 'package:pospredsvto/main/destinations.dart';
import 'package:pospredsvto/map/map.dart';

class RedactionChoise extends StatelessWidget {
  int index;
  RedactionChoise(this.index);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("Выбор редакции"),
          actions: <Widget>[
            Icon(Icons.search),
            Icon(Icons.filter_list),
            Icon(Icons.map)
          ],
        ),
      ),
    );
  }
}
