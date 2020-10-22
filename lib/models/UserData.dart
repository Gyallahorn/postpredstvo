// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.msg,
    this.user,
  });

  String msg;
  User user;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        msg: json["msg"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "user": user.toJson(),
      };
}

class User {
  User({
    this.lng,
    this.ltd,
    this.test,
    this.confirmed,
    this.isAdmin,
    this.id,
    this.email,
    this.password,
    this.v,
  });

  List<double> lng;
  List<int> ltd;
  List<Test> test;
  bool confirmed;
  bool isAdmin;
  String id;
  String email;
  String password;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        lng: List<double>.from(json["lng"].map((x) => x.toDouble())),
        ltd: List<int>.from(json["ltd"].map((x) => x)),
        test: List<Test>.from(json["test"].map((x) => Test.fromJson(x))),
        confirmed: json["confirmed"],
        isAdmin: json["isAdmin"],
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "lng": List<dynamic>.from(lng.map((x) => x)),
        "ltd": List<dynamic>.from(ltd.map((x) => x)),
        "test": List<dynamic>.from(test.map((x) => x.toJson())),
        "confirmed": confirmed,
        "isAdmin": isAdmin,
        "_id": id,
        "email": email,
        "password": password,
        "__v": v,
      };
}

class Test {
  Test({
    this.name,
    this.score,
  });

  String name;
  String score;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        name: json["name"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "score": score,
      };
}
