import 'package:flutter/material.dart';
import 'package:pospredsvto/main/home_bottom_nav_bar.dart';
import 'package:pospredsvto/main/tab_navigation.dart';
import 'package:pospredsvto/map/map.dart';

class MainFrame extends StatefulWidget {
  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: NavigationTab().widgetList[_currentIndex],
        bottomNavigationBar: HomeBottomNavBar(
          onTabTapped: onTabTapped,
          currentIndex: _currentIndex,
        ),
      ),
    );
  }
}

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  Widget build(BuildContext context) {
    return MapFrame();
  }
}
