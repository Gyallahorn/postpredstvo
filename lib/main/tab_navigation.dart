import 'package:flutter/material.dart';
import 'package:pospredsvto/main.dart';
import 'package:pospredsvto/map/map.dart';

class NavigationTab {
  final List<Widget> widgetList = [
    MapFrame(),
    Icon(Icons.person),
    Icon(Icons.remove_red_eye),
  ];
}
