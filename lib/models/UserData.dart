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
    this.confirmed,
    this.isAdmin,
    this.id,
    this.email,
    this.password,
    this.v,
  });

  List<double> lng;
  List<double> ltd;
  bool confirmed;
  bool isAdmin;
  String id;
  String email;
  String password;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        lng: List<double>.from(json["lng"].map((x) => x.toDouble())),
        ltd: List<double>.from(json["ltd"].map((x) => x.toDouble())),
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
        "confirmed": confirmed,
        "isAdmin": isAdmin,
        "_id": id,
        "email": email,
        "password": password,
        "__v": v,
      };
}
