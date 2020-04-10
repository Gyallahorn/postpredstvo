import 'package:flutter/material.dart';
import 'package:pospredsvto/map/map.dart';

class ChoosingDifficult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 180,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MapFrame()));
            },
            child: Center(
              child: Container(
                width: 200,
                height: 50,
                child: Text(
                  'Первый уровень \n (Москва)',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              width: 200,
              height: 50,
              child: Center(
                child: Text(
                    'Второй уровень \n (Московская обл. и Санкт-Петербург)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ),
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              width: 200,
              height: 50,
              child: Text(
                  'Третий уровень '
                  '\n'
                  '(Тверская обл. и Новгородская обл.)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
              color: Colors.grey,
            ),
          ),
        ],
      )),
    );
  }
}
