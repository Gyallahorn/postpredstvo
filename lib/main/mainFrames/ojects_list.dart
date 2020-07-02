import 'package:flutter/material.dart';
import 'package:pospredsvto/main/mainFrames/objects.dart';

class ObjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyObjectList(),
    );
  }
}

class MyObjectList extends StatefulWidget {
  @override
  _MyObjectListState createState() => _MyObjectListState();
}

class _MyObjectListState extends State<MyObjectList> {
  var listOfObjects = List<Widget>();
  void listBuilder() {
    for (int i = 1; i < objectsList.length; i++) {
      listOfObjects.add(GestureDetector(
          child: Column(children: [
        Container(
          child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQXBKqhH8VS4qdb6Lcu-6SOe0qKxQmZo3pJvQ&usqp=CAU"),
        ),
        Row(
          children: <Widget>[
            Text("example 1 "),
            Divider(
              color: Colors.grey,
            ),
            Text("4.9")
          ],
        ),
        SizedBox(
          height: 20,
        )
      ])));
    }
  }

  @override
  Widget build(BuildContext context) {
    listBuilder();
    return ListView(
      children: listOfObjects,
    );
  }
}
