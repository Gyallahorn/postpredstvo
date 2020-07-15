import 'package:flutter/material.dart';
import 'package:pospredsvto/main/mainFrames/objects.dart';
import 'package:rating_bar/rating_bar.dart';

import 'object_about.dart';

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
//  void listBuilder() {
//    for (int i = 1; i < objectsList.length; i++) {
//      listOfObjects.add;
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    listBuilder();
    return  ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: objectsList.length,

        itemBuilder: (BuildContext context , int index ){
          return (GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObjectAbout(),
                  ),
                ),
              },
              child: Column(children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQXBKqhH8VS4qdb6Lcu-6SOe0qKxQmZo3pJvQ&usqp=CAU"),
                        fit: BoxFit.fitWidth),
                  ),
                ),
                SizedBox(height: 10,),
                Container(

                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(Icons.near_me,size: 15,),
                      Text("example 1 "+"Км"),
                      SizedBox(width: 5,),
                      CircleAvatar(radius: 2.5,backgroundColor: Colors.black,),
                      SizedBox(width: 5,),
                      Text("Пеший тур"),
                      SizedBox(width: 125,),
                      VerticalDivider(),
                      Column(children: <Widget>[
                        Text("4.9"),
                        RatingBar.readOnly(filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        filledColor: Colors.red,
                        halfFilledIcon: Icons.star_half,
                        isHalfAllowed: true,
                        size: 10,
                        initialRating: 4.9,),
                        Row(
                          children: <Widget>[
                            Icon(Icons.person,size: 15,),
                            SizedBox(width: 5,),
                            Text("15"),
                          ],
                        )
                      ],),
                    ],
                  ),
                ),
                Divider(),
              ]),));
        },   separatorBuilder: (BuildContext context , int index){
      return SizedBox(height: 10,);
    },
    );
  }
}
