import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pospredsvto/map/map.dart';

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
          backgroundColor: Colors.white,
          title: Text("Тур",style: TextStyle(color: Colors.black),),
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.red,), 
            onPressed: (){Navigator.pop(context);},),
        ),
        body: ListView(children: <Widget>[
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Text("Уличное исскуство Якутска",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Text("Kirill.O",style: TextStyle(fontSize: 15)),
              SizedBox(width: 5,),
              Icon(Icons.arrow_forward_ios,size: 10,)
            ],
          ),SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Text("Пеший тур",style: TextStyle(fontSize: 18),),
              SizedBox(width: 120,),
              Icon(Icons.access_time,size: 10,),
              Text("1h 20m (5,3km)"),
          ],),
          SizedBox(height: 10,),
          Divider(indent: 20,endIndent: 20,color: Colors.grey,),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              GestureDetector(child: Row(children: <Widget>[
                Icon(Icons.play_arrow,size: 15,),
                SizedBox(width: 15,),
                Text("Слушать аудио")
              ],),),
            ],
          ),
          SizedBox(height: 10,),
          Divider(indent: 20,endIndent: 20,color: Colors.grey,),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              SizedBox(width: 25,),
              Container(
                height: 320,
                width: 360,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQXBKqhH8VS4qdb6Lcu-6SOe0qKxQmZo3pJvQ&usqp=CAU"),
                      fit: BoxFit.fill),
                ),
              ),
            ],
          ),SizedBox(height: 15,),
          Center(
            child: Row(children: <Widget>[
              SizedBox(width: 20,),
              GestureDetector(child: Container(child: FlatButton(child: Text("Скачать",style: TextStyle(color: Colors.white),)),color: Colors.grey,width: 180,)),
              SizedBox(width: 10,),
              GestureDetector(child: Container(child: FlatButton(child: Text("Начать",style: TextStyle(color: Colors.white),)),color: Colors.red,width: 180,),onTap: (){
                // Write func
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapFrame(),
                  ),
                );
              },)
            ],),
          ),SizedBox(height: 10,),
          Divider(indent: 20,endIndent: 20,color: Colors.grey,),
        ],),
      ),
    );
  }
}
