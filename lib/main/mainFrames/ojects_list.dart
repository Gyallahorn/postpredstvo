import 'package:flutter/material.dart';
import 'package:pospredsvto/main/mainFrames/objects.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setDiff(int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('dif', index);
    print(index);
  }

  @override
  Widget build(BuildContext context) {
//    listBuilder();

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: difficults.length,
      itemBuilder: (BuildContext context, int index) {
        return (GestureDetector(
          onTap: () => {
            setDiff(index),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ObjectAbout(index),
              ),
            ),
          },
          child: Column(children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(difficults[index]["link"].toString()),
                    fit: BoxFit.fitWidth),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.near_me,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 115,
                    child: Text(
                      difficults[index]["diff"].toString() +
                          " " +
                          difficults[index]["long"].toString(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    radius: 2.5,
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Пеший тур"),
                  SizedBox(
                    width: 110,
                  ),
                  VerticalDivider(),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text("4.9"),
                        RatingBar.readOnly(
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.red,
                          halfFilledIcon: Icons.star_half,
                          isHalfAllowed: true,
                          size: 10,
                          initialRating: 4.9,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("15"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ]),
        ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }
}
