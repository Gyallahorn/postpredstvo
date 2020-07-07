import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ObjectAbout extends StatefulWidget {
  @override
  _ObjectAboutState createState() => _ObjectAboutState();
}

class _ObjectAboutState extends State<ObjectAbout> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("sdsd"),
        ),
        body: Text("sadsad"),
      ),
    );
  }
}
