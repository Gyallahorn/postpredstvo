import 'package:flutter/material.dart';
import 'package:pospredsvto/regPages/startPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PostPosredstvo',
      color: Colors.green,
      home: StartPage(),
    );
  }
}
