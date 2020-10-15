// To parse this JSON data, do
//
//     final routes = routesFromJson(jsonString);

import 'dart:convert';

List<Routes> routesFromJson(String str) =>
    List<Routes>.from(json.decode(str).map((x) => Routes.fromJson(x)));

String routesToJson(List<Routes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Routes {
  Routes({
    this.id,
    this.lng,
    this.ltd,
    this.name,
    this.street,
    this.img,
    this.desc,
    this.difficult,
  });

  String id;
  double lng;
  double ltd;
  String name;
  String street;
  String img;
  String desc;
  String difficult;

  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
        id: json["_id"],
        lng: json["lng"].toDouble(),
        ltd: json["ltd"].toDouble(),
        name: json["name"],
        street: json["street"],
        img: json["img"],
        desc: json["desc"],
        difficult: json["difficult"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lng": lng,
        "ltd": ltd,
        "name": name,
        "street": street,
        "img": img,
        "desc": desc,
        "difficult": difficult,
      };
}
