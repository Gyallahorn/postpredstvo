import 'package:flutter/material.dart';
import 'package:pospredsvto/answer.dart';
import 'package:pospredsvto/cabinet/cabinet.dart';
import 'package:pospredsvto/main.dart';
import 'package:pospredsvto/map/map.dart';

class NavigationTab {
  final List<Widget> widgetList = [MapFrame(), Answers(), MyCabinet()];
}
