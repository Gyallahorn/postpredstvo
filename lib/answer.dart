import 'package:flutter/material.dart';

class Answers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print("pressed");
                },
                child: Container(
                  color: Colors.grey,
                  height: 50,
                  width: 300,
                  child: Text("sd"),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}
