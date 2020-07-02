import 'package:flutter/material.dart';
import 'package:pospredsvto/main/destinations.dart';
import 'package:pospredsvto/map/map.dart';

class MainScrollMenu extends StatelessWidget {
  final int index;
  MainScrollMenu(this.index);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("Обзор"),
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
