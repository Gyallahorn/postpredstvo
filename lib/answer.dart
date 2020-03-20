import 'package:flutter/material.dart';

class Answers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  print("pressed");
                },
                child: Container(
                  color: Colors.grey[300],
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
