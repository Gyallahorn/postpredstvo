import 'package:flutter/material.dart';
import 'package:pospredsvto/regPages/regPage/regpage3.dart';

class RegPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Text('Назад', style: TextStyle(color: Colors.grey))),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(65, 0, 0, 0),
            child: Text(
              'Регистрация',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        actions: <Widget>[
          Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegPage3()),
                    );
                  },
                  child: Text('Далее',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
            ),
          ])
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Мы отправим код подтверждения на \nуказанную почту',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                        child: Text('Почта')),
                    border: UnderlineInputBorder(),
                    hintText: 'example@gmail.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
